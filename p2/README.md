# 百度股票爬虫程序
### 背景：这个程序代码实现了爬取百度股票的相关信息功能，首先，在相关网站的选取上，考虑到新浪股票的页面加载使用js动态展示，相关信息并没有展示在网页的源代码html文件中，所以选择了相对较容易爬取的百度股票通网站。起初没有使用框架，程序运行的奇慢，所以套用了scrapy框架其中代码主要在spider.by和pipeline.py中，spider.py负责处理请求并调用def parse_stock(self, response)对页面进行解析，pipeline.py中定义了 BaidustocksInfoPipeline类负责将解析得到的数据存入文件BaiduStockInfo.txt中，此处注意需修改相关置文件：

    ITEM_PIPELINES = {
    'BaiduStocks.pipelines.BaidustocksInfoPipeline': 300,
}

##### 只是个入门级爬虫程序，还请大佬莫笑啊。
### 首先在（[东方财富网][1]）上爬取上交所和深交所相关股票的代号列表，具体方法为：
### (1)观察东方财富网的网页源代码，可以发现相关股票代号以超链接形式展示，使用css选择器获取属性节点后，利用正则表达式进行匹配，获取以sh或zh开头的股票代号，据此生成爬取股票信息的url ###

    for href in response.css('a::attr(href)').extract():
    try:
        stock = re.findall(r"[s][hz]\d{6}", href)[0]
        url = 'https://gupiao.baidu.com/stock/' + stock + '.html'
        yield scrapy.Request(url, callback=self.parse_stock)
    except:
        continue


### (2)观察百度股票通的网页源代码 ###
### 股票的相关信息节点层次清晰，所以使用css选择器和正则匹配等方式获取相应股票信息，存入字典infoDict ###
### 详细代码见下：

    infoDict = {}
        stockInfo = response.css('.stock-bets')
        name = stockInfo.css('.bets-name').extract()[0]
        keyList = stockInfo.css('dt').extract()
        valueList = stockInfo.css('dd').extract()
        for i in range(len(keyList)):
            key = re.findall(r'>.*</dt>', keyList[i])[0][1:-5]
            try:
                val = re.findall(r'\d+\.?.*</dd>', valueList[i])[0][0:-5]
            except:
                val = '--'
            infoDict[key] = val
        infoDict.update(
            {'股票名称': re.findall('\s.*\(', name)[0].split()[0] + \
                     re.findall('\>.*\<', name)[0][1:-1]})
        yield infoDict


### (3)后续 ###
#### 这几天稍微了解了beautifulsoup库和正则表达式的匹配规则，但是对于有ajax加载的网页的爬取还是力不从心，同时对sracy框架的掌握也不太熟练，只能照葫芦画瓢的写一些配置文件，我想请问后续深入的学习爬虫的话应该要从哪些方面继续深入呢？学习的过程中有哪些注意点呢？求学长赐教啊。


  [1]: http://quote.eastmoney.com/stocklist.html
