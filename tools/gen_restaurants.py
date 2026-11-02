# -*- coding: utf-8 -*-
"""Generate lib/data/restaurants_catalog.dart with 60 real Merida restaurants."""
from pathlib import Path
import math

USER_LAT, USER_LNG = 20.9671, -89.6237

IMAGES = {
    "Mexicana": [
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80",
        "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&q=80",
        "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80",
        "https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=800&q=80",
    ],
    "Hamburguesas": [
        "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80",
        "https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&q=80",
        "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80",
    ],
    "Sushi": [
        "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&q=80",
        "https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=800&q=80",
        "https://images.unsplash.com/photo-1553621042-f6e147245754?w=800&q=80",
    ],
    "Mariscos": [
        "https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80",
        "https://images.unsplash.com/photo-1615141982883-c7ad0e69fd62?w=800&q=80",
        "https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=800&q=80",
    ],
    "Cafeterías": [
        "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
        "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&q=80",
        "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&q=80",
    ],
    "Pizza": [
        "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80",
        "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&q=80",
        "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80",
    ],
    "Internacional": [
        "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80",
        "https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80",
        "https://images.unsplash.com/photo-1600891964599-f61ba0a33dd0?w=800&q=80",
    ],
}

# name, category, subcategory, colonia, lat, lng, rating, schedule, description, tags
RESTAURANTS = [
    # Centro Histórico / Santa Lucía / Santa Ana
    ("La Chaya Maya", "Mexicana", "Cocina yucateca", "Centro Histórico", 20.9698, -89.6228, 4.5, "Lun–Dom · 08:00 – 22:00", "Clásico de la cocina yucateca frente a Santa Lucía. Panuchos, salbutes y cochinita.", ["Yucateca", "Familiar"]),
    ("La Chaya Maya Casona", "Mexicana", "Cocina yucateca", "Parque Santa Lucía", 20.9704, -89.6219, 4.6, "Lun–Dom · 08:00 – 22:00", "Casona colonial con desayunos y platillos tradicionales de Yucatán.", ["Yucateca", "Desayunos"]),
    ("Museo de la Gastronomía Yucateca", "Mexicana", "Cocina yucateca", "Parque Santa Lucía", 20.9701, -89.6235, 4.6, "Lun–Dom · 08:00 – 18:00", "Experiencia gastronómica yucateca con ambiente de museo y mercado.", ["Yucateca", "Cultural"]),
    ("Apoala", "Mexicana", "Cocina oaxaqueña", "Parque Santa Lucía", 20.9706, -89.6225, 4.5, "Mar–Dom · 13:00 – 23:00", "Cocina oaxaqueña contemporánea en el corazón del Centro.", ["Oaxaqueña", "Terraza"]),
    ("Picheta", "Mexicana", "Yucateca contemporánea", "Plaza Grande", 20.9670, -89.6239, 4.4, "Lun–Dom · 13:00 – 23:00", "Rooftop con vista a la Catedral y cocina yucateca moderna.", ["Rooftop", "Vista"]),
    ("Oliva Enoteca", "Internacional", "Italiana", "Calle 47", 20.9732, -89.6210, 4.5, "Mar–Dom · 13:00 – 23:00", "Italiana de referencia en el corredor gastronómico de la 47.", ["Italiana", "Vinos"]),
    ("Pizzeria Oliva", "Pizza", "Pizza artesanal", "Calle 47", 20.9735, -89.6206, 4.7, "Mar–Dom · 13:00 – 23:00", "Pizzas artesanales con masa fermentada y horno de leña.", ["Pizza", "Artesanal"]),
    ("Ánima", "Internacional", "Cocina al fuego", "Calle 47", 20.9730, -89.6218, 4.5, "Mar–Dom · 13:00 – 23:00", "Cocina a fuego abierto en terraza con ambiente contemporáneo.", ["Fuego", "Terraza"]),
    ("Yakuza Sushi Centro", "Sushi", "Japonesa", "Calle 47", 20.9728, -89.6224, 4.5, "Mar–Dom · 13:00 – 23:00", "Sushi y cocina japonesa en el corredor gastronómico.", ["Sushi", "Frescos"]),
    ("La Tratto", "Pizza", "Pizza y bar", "Parque Santa Lucía", 20.9708, -89.6220, 4.4, "Lun–Dom · 13:00 – 00:00", "Pizza-bar del grupo Trotter en Santa Lucía.", ["Pizza", "Bar"]),
    ("130 Grados Steakhouse", "Mexicana", "Cortes y parrilla", "Calle 47", 20.9734, -89.6202, 4.4, "Mar–Dom · 13:00 – 23:00", "Steakhouse con cortes premium y ambiente sofisticado.", ["Parrilla", "Premium"]),
    ("Flamante Burgers", "Hamburguesas", "Burgers artesanales", "Calle 47", 20.9725, -89.6240, 4.4, "Lun–Dom · 13:00 – 23:00", "Hamburguesas independientes muy votadas en Mérida.", ["Burgers", "Casual"]),
    ("Huniik", "Mexicana", "Alta cocina yucateca", "Parque Santa Ana", 20.9758, -89.6226, 4.4, "Mar–Sáb · 19:00 – 23:00", "Alta cocina yucateca del chef Roberto Solís.", ["Fine dining", "Yucateca"]),
    ("Catrín", "Mexicana", "Cantina contemporánea", "Calle 47", 20.9731, -89.6214, 4.6, "Mar–Dom · 13:00 – 00:00", "Cantina moderna con cocina mexicana y cócteles.", ["Cantina", "Cócteles"]),
    ("Manjar Blanco", "Mexicana", "Cocina yucateca", "Parque Santa Ana", 20.9760, -89.6232, 4.5, "Lun–Dom · 08:00 – 18:00", "Desayunos y comida yucateca tradicional cerca de Santa Ana.", ["Desayunos", "Yucateca"]),
    ("Los Trompos Centro", "Mexicana", "Tacos al pastor", "Centro", 20.9688, -89.6245, 4.4, "Lun–Dom · 08:00 – 01:00", "Tacos al pastor y antojitos, clásico meridano.", ["Tacos", "Nocturno"]),
    ("La Parrilla Colonial", "Mexicana", "Cortes y parrilla", "Centro", 20.9685, -89.6238, 4.0, "Lun–Dom · 12:00 – 00:00", "Parrilla y ambiente colonial en el Centro Histórico.", ["Parrilla", "Terraza"]),
    ("Pancho's", "Mexicana", "Mexicana clásica", "Parque Santa Lucía", 20.9702, -89.6215, 4.2, "Lun–Dom · 18:00 – 00:00", "Restaurante mexicano icónico con show y ambiente festivo.", ["Show", "Familiar"]),
    ("Micaela Mar y Leña", "Mariscos", "Mar y leña", "Calle 47", 20.9733, -89.6216, 4.3, "Mar–Dom · 13:00 – 23:00", "Mariscos y cortes a la leña con coctelería.", ["Mariscos", "Leña"]),
    ("Tulia", "Mexicana", "Yucateca contemporánea", "Parque Santa Ana", 20.9755, -89.6220, 4.3, "Mar–Dom · 13:00 – 23:00", "Reinterpretación moderna de la cocina yucateca.", ["Contemporánea", "Local"]),
    # Montejo / Itzimná / García Ginerés
    ("Ku'uk", "Mexicana", "Alta cocina yucateca", "Itzimná", 20.9955, -89.6188, 4.8, "Mar–Sáb · 19:00 – 23:00", "Experiencia de tasting menu yucateco de clase mundial.", ["Fine dining", "Tasting"]),
    ("Yerba Santa", "Mexicana", "Mexicana contemporánea", "Paseo de Montejo", 20.9868, -89.6192, 4.7, "Mar–Dom · 13:00 – 23:00", "Cocina mexicana contemporánea en la casona El Minaret.", ["Contemporánea", "Casona"]),
    ("Delina Rooftop", "Internacional", "Rooftop bar", "Paseo de Montejo", 20.9869, -89.6190, 4.8, "Mar–Dom · 17:00 – 00:00", "Terraza de Yerba Santa con vista a Montejo y cócteles.", ["Rooftop", "Cócteles"]),
    ("José Rosé", "Internacional", "Bistro & grill", "Paseo de Montejo", 20.9855, -89.6198, 4.5, "Mar–Dom · 13:00 – 00:00", "Bistro con mariscos, pastas y cortes al fuego.", ["Grill", "Bar"]),
    ("TEYA Gastronomía Yucateca", "Mexicana", "Cocina yucateca", "Paseo de Montejo", 20.9848, -89.6202, 4.4, "Lun–Dom · 12:00 – 22:00", "Sabores yucatecos vivos en Paseo Montejo.", ["Yucateca", "Tradicional"]),
    ("La Tradición", "Mexicana", "Cocina yucateca", "Paseo de Montejo", 20.9875, -89.6185, 4.3, "Lun–Dom · 12:00 – 18:00", "Referente de cocina yucateca tradicional en Montejo.", ["Yucateca", "Clásico"]),
    ("Te Extraño Extraño", "Mexicana", "Contemporánea local", "Paseo de Montejo", 20.9850, -89.6208, 4.5, "Mar–Dom · 09:00 – 22:00", "Cocina contemporánea con productos locales y mixología.", ["Local", "Mixología"]),
    ("Hennessy's Irish Pub", "Internacional", "Pub irlandés", "Paseo de Montejo", 20.9820, -89.6215, 4.4, "Lun–Dom · 12:00 – 01:00", "Pub irlandés de Montejo con comfort food y cervezas.", ["Pub", "Cerveza"]),
    ("Néctar", "Mexicana", "Alta cocina", "García Ginerés", 20.9788, -89.6285, 4.6, "Mar–Sáb · 19:00 – 23:00", "Alta cocina mexicana con técnica contemporánea.", ["Fine dining", "Mexicana"]),
    ("Rosas & Xocolate Restaurant", "Internacional", "Fusión", "Paseo de Montejo", 20.9810, -89.6210, 4.5, "Lun–Dom · 07:00 – 23:00", "Restaurante del hotel boutique con cocina de autor.", ["Boutique", "Desayunos"]),
    ("Trotter's", "Internacional", "Internacional", "García Ginerés", 20.9795, -89.6305, 4.4, "Lun–Dom · 13:00 – 00:00", "Clásico internacional del grupo Trotter en el norte.", ["Internacional", "Bar"]),
    ("Bella Repubblica", "Pizza", "Italiana", "Montejo Norte", 20.9905, -89.6175, 4.3, "Mar–Dom · 13:00 – 23:00", "Italiana con pastas y pizzas en zona Montejo.", ["Italiana", "Pasta"]),
    ("Café Impala", "Cafeterías", "Café y brunch", "Paseo de Montejo", 20.9835, -89.6205, 4.2, "Lun–Dom · 08:00 – 22:00", "Café icónico de Montejo para desayunos y reuniones.", ["Café", "Clásico"]),
    ("La Recova", "Internacional", "Parrilla argentina", "Colonia México", 20.9800, -89.6150, 4.4, "Mar–Dom · 13:00 – 23:00", "Parrilla argentina con cortes y ambiente íntimo.", ["Argentina", "Parrilla"]),
    # Altabrisa / Plaza / Norte
    ("Los Trompos Altabrisa", "Mexicana", "Tacos al pastor", "Altabrisa", 20.9989, -89.6168, 4.0, "Lun–Dom · 08:00 – 02:00", "Sucursal norte de Los Trompos, ideal de noche.", ["Tacos", "Nocturno"]),
    ("Boston's Pizza Altabrisa", "Pizza", "Pizza americana", "Altabrisa", 20.9995, -89.6155, 4.1, "Lun–Dom · 12:00 – 00:00", "Pizzas, pastas y deportes en Altabrisa.", ["Pizza", "Familiar"]),
    ("Samy's Altabrisa", "Mexicana", "Antojitos", "Altabrisa", 20.9978, -89.6148, 4.2, "Lun–Dom · 08:00 – 22:00", "Antojitos yucatecos y comida rápida norteña.", ["Antojitos", "Rápido"]),
    ("Sushi Itto Altabrisa", "Sushi", "Sushi rolls", "Altabrisa", 21.0002, -89.6172, 4.3, "Lun–Dom · 13:00 – 23:00", "Cadena de sushi con rolls creativos.", ["Sushi", "Rolls"]),
    ("Burger King Altabrisa", "Hamburguesas", "Fast food", "Altabrisa", 20.9980, -89.6185, 3.9, "Lun–Dom · 08:00 – 00:00", "Hamburguesas rápidas en zona comercial Altabrisa.", ["Rápido", "Familiar"]),
    ("Italian Coffee Altabrisa", "Cafeterías", "Café", "Altabrisa", 20.9990, -89.6140, 4.2, "Lun–Dom · 08:00 – 22:00", "Café, postres y bebidas frías en plaza.", ["Café", "Postres"]),
    ("La Casa de los Tamales Norte", "Mexicana", "Tamales yucatecos", "Francisco de Montejo", 21.0055, -89.6200, 4.4, "Lun–Dom · 08:00 – 16:00", "Tamales yucatecos y desayunos regionales.", ["Tamales", "Desayunos"]),
    ("Mariscos El Bayo Norte", "Mariscos", "Mariscos frescos", "Francisco de Montejo", 21.0080, -89.6180, 4.3, "Mar–Dom · 11:00 – 18:00", "Ceviches, cócteles y pescado fresco.", ["Ceviche", "Frescos"]),
    ("Pizza Hut Plaza Altabrisa", "Pizza", "Pizza", "Altabrisa", 20.9970, -89.6160, 3.8, "Lun–Dom · 11:00 – 23:00", "Pizza familiar en plaza comercial.", ["Pizza", "Familiar"]),
    ("Starbucks Altabrisa", "Cafeterías", "Café", "Altabrisa", 20.9998, -89.6158, 4.1, "Lun–Dom · 07:00 – 22:00", "Café para trabajar o esperar tu turno cerca.", ["Café", "WiFi"]),
    # Plaza Américas / Ciudad Caucel / Poniente
    ("Burger House Plaza Américas", "Hamburguesas", "Burgers gourmet", "Plaza Américas", 21.0008, -89.6132, 4.6, "Lun–Dom · 11:00 – 22:00", "Burgers artesanales en Plaza Américas.", ["Burgers", "Gourmet"]),
    ("Sushi Garden Montejo", "Sushi", "Japonesa contemporánea", "Montejo", 20.9860, -89.6195, 4.7, "Mar–Dom · 13:00 – 22:30", "Sushi fresco y rolls creativos cerca de Montejo.", ["Sushi", "Romántico"]),
    ("El Fogoncito Yucateco", "Mexicana", "Cocina yucateca", "Centro", 20.9688, -89.6221, 4.9, "Lun–Sáb · 12:00 – 21:00", "Cochinita, panuchos y sopa de lima al estilo casero.", ["Yucateca", "Local"]),
    ("Café Paladar", "Cafeterías", "Café de especialidad", "García Ginerés", 20.9785, -89.6350, 4.4, "Lun–Dom · 08:00 – 20:00", "Café de especialidad, pasteles y brunch.", ["Café", "Brunch"]),
    ("Mar y Sol", "Mariscos", "Mariscos", "Norte", 21.0062, -89.6215, 4.5, "Mié–Dom · 12:00 – 20:00", "Ceviches y pescado a la talla en el norte de la ciudad.", ["Mariscos", "Familiar"]),
    ("Wayan'e", "Mexicana", "Tacos de cochinita", "Varias colonias", 20.9740, -89.6105, 4.6, "Lun–Sáb · 07:00 – 14:00", "Famosos tacos de cochinita yucateca.", ["Cochinita", "Desayunos"]),
    # Oriente / Sur / otras zonas
    ("Taquería de la Unión", "Mexicana", "Tacos", "Centro Oriente", 20.9655, -89.6120, 4.3, "Lun–Dom · 18:00 – 02:00", "Tacos nocturnos muy frecuentados por locales.", ["Tacos", "Nocturno"]),
    ("Los Almendros Mérida", "Mexicana", "Cocina yucateca", "Centro", 20.9665, -89.6210, 4.2, "Lun–Dom · 12:00 – 21:00", "Clásico yucateco con platillos de antaño.", ["Yucateca", "Clásico"]),
    ("Amaro", "Internacional", "Mediterránea", "Centro", 20.9690, -89.6255, 4.3, "Mar–Dom · 13:00 – 23:00", "Cocina mediterránea en casona del Centro.", ["Mediterránea", "Terraza"]),
    ("La Casa de Frida", "Mexicana", "Mexicana", "Centro", 20.9715, -89.6260, 4.1, "Mar–Dom · 13:00 – 22:00", "Ambiente colorido con cocina mexicana.", ["Mexicana", "Familiar"]),
    ("Mercado 60 Food Hall", "Internacional", "Food hall", "Centro", 20.9710, -89.6248, 4.4, "Mar–Dom · 17:00 – 01:00", "Variedad de puestos, música y ambiente nocturno.", ["Food hall", "Bar"]),
    ("El Trapiche", "Cafeterías", "Helados y café", "Centro", 20.9678, -89.6225, 4.3, "Lun–Dom · 10:00 – 22:00", "Helados, neverías y café cerca de Plaza Grande.", ["Helados", "Familiar"]),
    ("Pizza del Perro Negro Centro", "Pizza", "Pizza y craft beer", "Centro", 20.9720, -89.6230, 4.4, "Lun–Dom · 13:00 – 00:00", "Pizzas y cerveza artesanal en ambiente relajado.", ["Pizza", "Cerveza"]),
    ("Sushi Roll Plaza Fiesta", "Sushi", "Sushi", "Norte", 21.0025, -89.6225, 4.2, "Lun–Dom · 13:00 – 22:00", "Rolls y combinados en plaza del norte.", ["Sushi", "Familiar"]),
    ("Las Empanadas del Sur", "Mexicana", "Empanadas", "Sur", 20.9450, -89.6250, 4.3, "Lun–Dom · 08:00 – 20:00", "Empanadas yucatecas y antojitos en el sur.", ["Antojitos", "Local"]),
    ("Cocina Económica El Parque", "Mexicana", "Comida corrida", "Kanasín colindante", 20.9550, -89.6050, 4.0, "Lun–Sáb · 08:00 – 17:00", "Comida corrida casera a buen precio.", ["Económica", "Local"]),
]

assert len(RESTAURANTS) == 60, len(RESTAURANTS)


def haversine_m(lat1, lon1, lat2, lon2):
    R = 6371000
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = math.radians(lat2 - lat1)
    dl = math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * R * math.asin(math.sqrt(a))


def dist_label(meters):
    if meters < 1000:
        return f"{int(round(meters / 10) * 10)} m"
    return f"{meters / 1000:.1f} km"


def esc(s):
    return s.replace("\\", "\\\\").replace("'", "\\'")


def main():
    lines = []
    lines.append("// GENERATED — 60 restaurantes reales en Mérida, Yucatán.")
    lines.append("// ignore_for_file: prefer_const_constructors")
    lines.append("")
    lines.append("import '../models/restaurant.dart';")
    lines.append("")
    lines.append("class RestaurantsCatalog {")
    lines.append("  static List<Restaurant> get all => [")

    for i, r in enumerate(RESTAURANTS, start=1):
        name, cat, sub, colonia, lat, lng, rating, schedule, desc, tags = r
        meters = haversine_m(USER_LAT, USER_LNG, lat, lng)
        distance = dist_label(meters)
        # Deterministic wait/people from index
        wait = 8 + ((i * 7) % 40)
        people = 2 + ((i * 3) % 18)
        status = "QueueStatus.busy" if wait > 38 else "QueueStatus.open"
        imgs = IMAGES.get(cat, IMAGES["Mexicana"])
        img = imgs[i % len(imgs)]
        tags_lit = ", ".join(f"'{esc(t)}'" for t in tags)
        lines.append(f"    Restaurant(")
        lines.append(f"      id: 'r{i}',")
        lines.append(f"      name: '{esc(name)}',")
        lines.append(f"      category: '{esc(cat)}',")
        lines.append(f"      subcategory: '{esc(sub)}',")
        lines.append(f"      imageUrl: '{img}',")
        lines.append(f"      rating: {rating},")
        lines.append(f"      distance: '{distance}',")
        lines.append(f"      waitMinutes: {wait},")
        lines.append(f"      peopleWaiting: {people},")
        lines.append(f"      queueStatus: {status},")
        lines.append(f"      location: '{esc(colonia)}, Mérida',")
        lines.append(f"      schedule: '{esc(schedule)}',")
        lines.append(f"      description: '{esc(desc)}',")
        lines.append(f"      tags: [{tags_lit}],")
        lines.append(f"      latitude: {lat},")
        lines.append(f"      longitude: {lng},")
        lines.append(f"    ),")

    lines.append("  ];")
    lines.append("}")
    lines.append("")

    out = Path("lib/data/restaurants_catalog.dart")
    out.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {out} with {len(RESTAURANTS)} restaurants")


if __name__ == "__main__":
    main()
