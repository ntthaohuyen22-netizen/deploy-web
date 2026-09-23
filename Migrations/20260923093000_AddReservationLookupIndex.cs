using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MenuGoBE.Migrations
{
    /// <inheritdoc />
    public partial class AddReservationLookupIndex : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Composite index to speed up the ReservationMonitorService scan:
            //   WHERE Status = 'Pending' AND OrderId IS NULL
            //     AND ReservationTime <= @lockThreshold AND ReservationTime > @expiredTime
            migrationBuilder.Sql(
                @"CREATE INDEX IF NOT EXISTS ""IX_Reservations_Status_OrderId_ReservationTime""
                  ON ""Reservations"" (""Status"", ""OrderId"", ""ReservationTime"");");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(
                @"DROP INDEX IF EXISTS ""IX_Reservations_Status_OrderId_ReservationTime"";");
        }
    }
}
