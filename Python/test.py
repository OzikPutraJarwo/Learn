from scholarly import scholarly

def search_scholarly(keyword, max_results=5):
    search_query = scholarly.search_pubs(keyword)
    articles = []
    
    for i in range(max_results):
        try:
            article = next(search_query)
            pub_year_str = article.get('bib', {}).get('pub_year', '0')
            link = article.get('eprint_url', None)
            try:
                pub_year = int(pub_year_str)
            except ValueError:
                pub_year = 0
            if pub_year >= 2004 and link:
                articles.append(article)
        except StopIteration:
            break

    return articles

def main(keywords, max_results_per_keyword=5):
    all_articles = []
    
    for keyword in keywords:
        found_articles = False
        while not found_articles:
            articles = search_scholarly(keyword, max_results_per_keyword)
            if articles:
                all_articles.extend(articles)
                found_articles = True
            else:
                print(f"No articles found for keyword '{keyword}' with the given filters. Trying again...")

    for article in all_articles:
        title = article.get('bib', {}).get('title', 'No Title')
        author = article.get('bib', {}).get('author', 'No Author')
        pub_year = article.get('bib', {}).get('pub_year', 'No Year')
        link = article.get('eprint_url', 'No Link Available')

        print(f"Title: {title}")
        print(f"Author: {author}")
        print(f"Publication Year: {pub_year}")
        print(f"Link: {link}\n")

if __name__ == "__main__":
    keywords = ["soybean plant architecture"]
    main(keywords)
    

