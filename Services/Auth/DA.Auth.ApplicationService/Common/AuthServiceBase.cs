﻿using DA.Auth.Infrastructure;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DA.Auth.ApplicationService.Common
{
    public abstract class AuthServiceBase
    {
        protected readonly ILogger _logger;
        protected readonly AuthDbContext _dbContext;

        protected AuthServiceBase(ILogger logger, AuthDbContext dbContext)
        {
            _logger = logger;
            _dbContext = dbContext;
        }
    }
}
