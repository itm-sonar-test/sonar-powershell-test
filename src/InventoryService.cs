using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;

namespace Itmethods.SonarTest
{
    /// <summary>
    /// Control fixture in a GA language. The PowerShell scripts alongside this
    /// file carry equivalent planted issues. If C# issues are reported and the
    /// PowerShell ones are not, the coverage boundary is demonstrated in a
    /// single project.
    /// </summary>
    public class InventoryService
    {
        // ISSUE: hardcoded credentials, same as the PowerShell fixtures.
        private const string ConnectionString =
            "Server=db-prod-01;Database=Inventory;User Id=sa;Password=Sup3rSecret!;";

        private const string ApiKey = "a7f3c9e1b4d85206f1e3a9c7d2b60845";

        private readonly List<string> _servers = new List<string>
        {
            "app-prod-01",
            "app-prod-02",
            "db-prod-01"
        };

        public IEnumerable<string> GetServers()
        {
            return _servers;
        }

        // ISSUE: SQL injection - unsanitised input concatenated into the query.
        public int CountByName(string name)
        {
            var sql = "SELECT COUNT(*) FROM Servers WHERE Name = '" + name + "'";

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                using (var command = new SqlCommand(sql, connection))
                {
                    return (int)command.ExecuteScalar();
                }
            }
        }

        // ISSUE: certificate validation disabled, mirrors Get-Inventory.ps1.
        public void ConfigureClient()
        {
            ServicePointManager.ServerCertificateValidationCallback =
                (sender, certificate, chain, errors) => true;
        }

        // ISSUE: duplicated branches - two arms return the same value.
        public string GetDeploymentTarget(string environment)
        {
            if (environment == "prod")
            {
                return "https://deploy.internal.example.com/prod";
            }
            else if (environment == "staging")
            {
                return "https://deploy.internal.example.com/staging";
            }
            else if (environment == "uat")
            {
                return "https://deploy.internal.example.com/staging";
            }

            return "https://deploy.internal.example.com/dev";
        }

        // ISSUE: empty catch swallows the failure, mirrors Deploy-App.ps1.
        public void Deploy(string package)
        {
            try
            {
                Console.WriteLine("Deploying " + package + " with key " + ApiKey);
            }
            catch (Exception)
            {
            }
        }

        // ISSUE: always-true condition.
        public bool IsPathValid(string path)
        {
            if (path != null || true)
            {
                return true;
            }

            return false;
        }

        // ISSUE: unreachable code after return.
        public string Describe()
        {
            return "InventoryService";
            Console.WriteLine("This line can never execute");
        }
    }
}
