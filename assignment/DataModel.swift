import ObjectMapper

class DataModel: Mappable {
    var search: [SearchBean] = []
    var totalResults: Int?
    var response: Bool?

    init() {}
    required init?(map: Map) {}

    func mapping(map: Map) {
        search <- map["Search"]
        totalResults <- map["totalResults"]
        response <- map["Response"]
    }
}

class SearchBean: Mappable {
    var year: String?
    var type: String?
    var poster: String?
    var imdbID: String?
    var title: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        year <- map["Year"]
        type <- map["Type"]
        poster <- map["Poster"]
        imdbID <- map["imdbID"]
        title <- map["Title"]
    }
    
    static let currentYear = Int(DateFormatter(withFormat: "yyyy", locale: "").string(from: Date()))
    private var resolvedYear: String!
    
    func resolveYear() -> String {
        guard let currentYear = SearchBean.currentYear else { return "error" }
        if resolvedYear != nil { return resolvedYear }
        if let yearString = year {
            let years = yearString.split(separator: "-")
            if years.count == 1, let year = Int(String(years.first!)) {
                let diff = currentYear - year
                if diff > 0 {
                    resolvedYear = String(diff) + " years ago"
                } else if diff < 0 {
                    resolvedYear = "upcomming"
                } else {
                    resolvedYear = "This year"
                }
            } else {
                resolvedYear = yearString
            }
        } else {
            resolvedYear = "Year unknown"
        }
        return resolvedYear
    }
}
