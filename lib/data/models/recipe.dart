
import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
    final String id;
    final String title;
    final String? text;
    final String? image;
    final String? link;
    final String? prepTime;
    final DateTime? dateAdded;
    final List<Energy> energy;
    final List<RecipeIngredient> ingredientsOne;
    final List<RecipeIngredient> ingredientsTwo;
    final List<RecipeStep> steps;

    const Recipe({
        required this.id,
        required this.title,
        this.text,
        this.image,
        this.link,
        this.prepTime,
        this.dateAdded,
        this.energy = const [],
        this.ingredientsOne = const [],
        this.ingredientsTwo = const [],
        this.steps = const [],
    });

    Recipe copyWith({
        String? id,
        String? title,
        String? text,
        String? image,
        String? link,
        String? prepTime,
        DateTime? dateAdded,
        List<Energy>? energy,
        List<RecipeIngredient>? ingredientsOne,
        List<RecipeIngredient>? ingredientsTwo,
        List<RecipeStep>? steps,
    }) => 
        Recipe(
            id: id ?? this.id,
            title: title ?? this.title,
            text: text ?? this.text,
            image: image ?? this.image,
            link: link ?? this.link,
            prepTime: prepTime ?? this.prepTime,
            dateAdded: dateAdded ?? this.dateAdded,
            energy: energy ?? this.energy,
            ingredientsOne: ingredientsOne ?? this.ingredientsOne,
            ingredientsTwo: ingredientsTwo ?? this.ingredientsTwo,
            steps: steps ?? this.steps,
        );

    factory Recipe.fromJson(Map<String, dynamic> json) {
        DateTime? parsedDate;
        try {
            final dateStr = json["date_added"];
            if (dateStr != null && dateStr.toString().isNotEmpty) {
                parsedDate = DateTime.parse(dateStr.toString());
            }
        } catch (_) {
            parsedDate = null;
        }

        return Recipe(
            id: json["id"]?.toString() ?? '',
            title: json["title"]?.toString() ?? '',
            text: json["text"]?.toString(),
            image: json["image"]?.toString(),
            link: json["link"]?.toString(),
            prepTime: json["prep_time"]?.toString(),
            dateAdded: parsedDate,
            energy: json["energy"] != null
                ? List<Energy>.from(
                    (json["energy"] as List)
                        .map((x) => Energy.fromJson(x as Map<String, dynamic>))
                )
                : [],
            ingredientsOne: json["ingredients_one"] != null
                ? List<RecipeIngredient>.from(
                    (json["ingredients_one"] as List)
                        .map((x) => RecipeIngredient.fromJson(
                            x as Map<String, dynamic>
                        ))
                )
                : [],
            ingredientsTwo: json["ingredients_two"] != null
                ? List<RecipeIngredient>.from(
                    (json["ingredients_two"] as List)
                        .map((x) => RecipeIngredient.fromJson(
                            x as Map<String, dynamic>
                        ))
                )
                : [],
            steps: json["steps"] != null
                ? List<RecipeStep>.from(
                    (json["steps"] as List)
                        .map((x) => RecipeStep.fromJson(
                            x as Map<String, dynamic>
                        ))
                )
                : [],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "image": image,
        "link": link,
        "prep_time": prepTime,
        "date_added": dateAdded?.toIso8601String(),
        "energy": energy.map((x) => x.toJson()).toList(),
        "ingredients_one": ingredientsOne.map((x) => x.toJson()).toList(),
        "ingredients_two": ingredientsTwo.map((x) => x.toJson()).toList(),
        "steps": steps.map((x) => x.toJson()).toList(),
    };
}

class Energy {
    final String title;
    final String text;

    const Energy({
        required this.title,
        required this.text,
    });

    Energy copyWith({
        String? title,
        String? text,
    }) => 
        Energy(
            title: title ?? this.title,
            text: text ?? this.text,
        );

    factory Energy.fromJson(Map<String, dynamic> json) => Energy(
        title: json["title"]?.toString() ?? '',
        text: json["text"]?.toString() ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
    };
}
class RecipeIngredient {
    final String title;
    final String text;

    const RecipeIngredient({
        required this.title,
        required this.text,
    });

    RecipeIngredient copyWith({
        String? title,
        String? text,
    }) => 
        RecipeIngredient(
            title: title ?? this.title,
            text: text ?? this.text,
        );

    factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
        RecipeIngredient(
            title: json["title"]?.toString() ?? '',
            text: json["text"]?.toString() ?? '',
        );

    Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
    };
}

class RecipeStep {
    final String text;
    final String? image1;
    final String? image2;

    const RecipeStep({
        required this.text,
        this.image1,
        this.image2,
    });

    RecipeStep copyWith({
        String? text,
        String? image1,
        String? image2,
    }) => 
        RecipeStep(
            text: text ?? this.text,
            image1: image1 ?? this.image1,
            image2: image2 ?? this.image2,
        );

    factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
        text: json["text"]?.toString() ?? '',
        image1: json["image1"]?.toString(),
        image2: json["image2"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "image1": image1,
        "image2": image2,
    };
}
