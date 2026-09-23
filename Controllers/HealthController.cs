using Microsoft.AspNetCore.Mvc;

namespace MenuGo.Controllers;

[ApiController]
[Route("[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet("")]
    [HttpGet("/health")]
    public IActionResult Get()
    {
        return Ok(new
        {
            status = "ok",
            timestamp = DateTime.UtcNow
        });
    }
}
