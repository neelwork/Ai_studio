class GetChatHistoryModel {
  String? status;
  String? message;
  Data? data;

  GetChatHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetChatHistoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Last30Days? today;
  Last30Days? yesterday;
  Last30Days? last7Days;
  Last30Days? last30Days;
  Last30Days? previousMonth;

  Data({
    this.today,
    this.yesterday,
    this.last7Days,
    this.last30Days,
    this.previousMonth,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        today:
            json["today"] == null ? null : Last30Days.fromJson(json["today"]),
        yesterday: json["yesterday"] == null
            ? null
            : Last30Days.fromJson(json["yesterday"]),
        last7Days: json["last_7_days"] == null
            ? null
            : Last30Days.fromJson(json["last_7_days"]),
        last30Days: json["last_30_days"] == null
            ? null
            : Last30Days.fromJson(json["last_30_days"]),
        previousMonth: json["previous_month"] == null
            ? null
            : Last30Days.fromJson(json["previous_month"]),
      );

  Map<String, dynamic> toJson() => {
        "today": today?.toJson(),
        "yesterday": yesterday?.toJson(),
        "last_7_days": last7Days?.toJson(),
        "last_30_days": last30Days?.toJson(),
        "previous_month": previousMonth?.toJson(),
      };
}

class Last30Days {
  int? total;
  int? page;
  int? pageSize;
  List<Prompt>? prompts;

  Last30Days({
    this.total,
    this.page,
    this.pageSize,
    this.prompts,
  });

  factory Last30Days.fromJson(Map<String, dynamic> json) => Last30Days(
        total: json["total"],
        page: json["page"],
        pageSize: json["page_size"],
        prompts: json["prompts"] == null
            ? []
            : List<Prompt>.from(
                json["prompts"]!.map((x) => Prompt.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "page_size": pageSize,
        "prompts": prompts == null
            ? []
            : List<dynamic>.from(prompts!.map((x) => x.toJson())),
      };
}

class Prompt {
  String? promptId;
  String? title;
  DateTime? createdAt;

  Prompt({
    this.promptId,
    this.title,
    this.createdAt,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) => Prompt(
        promptId: json["prompt_id"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "prompt_id": promptId,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
      };
}
