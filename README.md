# ZhihuDailyReport

这是一个仿知乎日报的App，数据的来源均来自知乎日报。


###添加上拉刷新

下拉刷新的代码在Refresh文件夹下
	
使用:
	
	tableView.addRefreshFooter { [weak self] refreshView in
      guard let strongSelf = self else { return }
      // TODO
    }		
		