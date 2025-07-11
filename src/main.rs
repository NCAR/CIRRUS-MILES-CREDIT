use actix_web::{get, App, HttpServer, Responder, HttpResponse};

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body("Hello from Actix!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(index))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}
