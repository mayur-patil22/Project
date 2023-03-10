/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class AutomobileLifecycle extends Contract {
    async InitLedger(ctx){
        const vehicles = [
            {
                VehicleID: "10001",
                Make: "Honda",
                Model: "City",
                Color: "Silver",
                Owner: "",
                Lifecycle: "Manufacturer",
                InsuranceStatus: "No",
                RegistrationStatus: "No",
                RegistrationDate: "",
                CarServiceStatus: "No",
                ScrapStatus: "No"
            }
        ];

        for (const vehicle of vehicles) {
            vehicle.docType = 'vehicle';
            await ctx.stub.putState(vehicle.VehicleID, Buffer.from(JSON.stringify(vehicle)));
            console.info(`Vehicle ${vehicle.VehicleID} intitialized`);
        }
    }

    //exist check for vehicle
    async vehicleExists(ctx, vehicleId) {
        const vehicleJSON = await ctx.stub.getState(vehicleId);
        return vehicleJSON && vehicleJSON.length > 0;
    }

    //create vehicle
    async createVehicle(ctx, vehicleId, make, model, color) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        // if (args.length != 4 || vehicleExists) {
        //     throw new Error("insufficient information or vehicle already exists");
        // }
        const vehicle = {
            VehicleID: vehicleId,
            Make: make,
            Model: model,
            Color: color,
            Owner: "",
            Lifecycle: "Manufacturer",
            InsuranceStatus: "No",
            RegistrationStatus: "No",
            RegistrationDate: "",
            CarServiceStatus: "No",
            ScrapStatus: "No"
        };
        await ctx.stub.putState(vehicleId, Buffer.from(JSON.stringify(vehicle)));
        return JSON.stringify(vehicle);
    }

    //read the vehicle from ledger
    async readVehicle(ctx, vehicleId) {
        const vehicleJSON = await ctx.stub.getState(vehicleId); 
        if (!vehicleJSON || vehicleJSON.length === 0) {
            throw new Error(`The vehicle ${vehicleId} does not exist`);
        }
        return vehicleJSON.toString();
    }

    //transfer to dealer
    async transferToDealer(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 1 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Manufacturer") {
            vehicle.Lifecycle = "Dealer";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //transfer to owner
    async transferToOwner(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 2 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Dealer") {
            vehicle.Lifecycle = "Regulator";
            vehicle.Owner = args[1];
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //apply for insurance
    async updateInsurance(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 1 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Regulator") {
            vehicle.InsuranceStatus = "Yes";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //request for registration
    async requestForRegistration(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 1 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Regulator" && vehicle.Owner.length != 0) {
            vehicle.RegistrationStatus = "Pending";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //approve the request for registration
    async approveRegistration(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 2 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Regulator") {
            vehicle.Lifecycle = "Owner"
            vehicle.RegistrationDate = args[1];
            vehicle.RegistrationStatus = "Yes";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //request for car service
    async requestForService(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 1 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        if (vehicle.Lifecycle === "Owner") {
            vehicle.CarServiceStatus = "Yes";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //regualtor order to scrap the vehicle
    async transferToScrap(ctx, args) {
        const vehicleExists = await this.vehicleExists(ctx, args[0]);
        if (args.length != 1 || !vehicleExists) {
            throw new Error("insufficient information or vehicle does not exist");
        }
        const vehicleString = await this.readVehicle(ctx, args[0]);
        const vehicle = JSON.parse(vehicleString);
        const vehicleAge = Date.now() - vehicle.RegistrationDate;
        if (vehicle.Lifecycle === "Owner" && vehicleAge >= 15) {
            vehicle.ScrapStatus = "Yes";
            vehicle.Lifecycle = "Scrap";
            return ctx.stub.putState(args[0], Buffer.from(JSON.stringify(vehicle)));
        }
    }

    //get history for all vehicles
    async getAllVehicles(ctx) {
        const allResults = [];
        const iterator = await ctx.stub.getStateByRange('', '');
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ key: result.value.key, record });
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

}

module.exports = AutomobileLifecycle;