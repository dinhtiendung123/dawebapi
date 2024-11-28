﻿using DA.Vehicle.Domain;
using DA.Vehicle.Dtos.BusModule;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DA.Vehicle.ApplicationService.BusModule.Abstracts
{
    public interface IBusService
    {
        Task AddBusAsync(CreateBusDto input);
        Task UpdateBusAsync(UpdateBusDto input);
        Task DeleteBusAsync(int id);
        Task<List<VehicleSeat>> GetAllSeatsAsync(int busId);
        Task<List<VehicleSeat>> GetSeatsByStatusAsync(int busId, int status);
    }
}
