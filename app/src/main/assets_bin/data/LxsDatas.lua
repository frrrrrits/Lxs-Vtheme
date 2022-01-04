local LxsDatas={}

LxsDatas.baseGlobalUrl = "https://asia-theme-api.vivoglobal.com"
LxsDatas.globalPathSearch = string.format("%s/search/query.do", LxsDatas.baseGlobalUrl)
LxsDatas.globalPathDetails = string.format("%s/v3/resource/details", LxsDatas.baseGlobalUrl)

LxsDatas.cnUrl = "https://stheme.vivo.com.cn"
LxsDatas.cnPathDetails = "https://theme.vivo.com.cn/v3/resource/details"

LxsDatas.globalPostTheme = function(page, query)
  return string.format("%s?tt=1&countrycode=ID&vosSupportLockScreen=1&sysVer=PD2055D_A_1.10.5&locale=in&sysromver=11&startIndex=%d&themetype=1&setId=-1&model=v2055A&lang=in-ID&pixel=3.0&apppkgName=com.bbk.theme&height=2400&romVer=4.2&mktprdmodel=v2055A&appversion=8.6.1.4&resId=&adrVerName=11&cfrom=404&cs=0&av=28&hots=%s&width=1080&immersiveBanner=true&appvercode=8614&promodel=PD2055D_A&category=1", LxsDatas.globalPathSearch, page, query)
end

LxsDatas.globalPostThemeDetail = function(packageId, resId)
  return string.format("%s?countrycode=ID&locale=ID&lang=in-ID&pixel=3.0&apppkgName=com.bbk.theme&height=1920&packageId=%s&appversion=6.9.3.4&vos20=0&resId=%s&cfrom=404&cs=0&av=28&width=1080&immersiveBanner=true&appvercode=6934&", LxsDatas.globalPathDetails, packageId, resId)
end

LxsDatas.globalPosFonts = function(page, query)
  return string.format("%s?tt=4&countrycode=ID&vosSupportLockScreen=0&sysVer=PD2055D_A_1.10.5&locale=ID&sysromver=11&startIndex=%d&themetype=4&setId=-1&model=v2055A&lang=ID&pixel=3.0&apppkgName=com.bbk.theme&height=2400&romVer=4.2&mktprdmodel=v2055A&appversion=8.6.1.4&vos20=0&resId=&adrVerName=11&cfrom=503&cs=0&av=28&hots=%s&width=1080&immersiveBanner=true&appvercode=8614&promodel=PD2055D_A&category=4&",LxsDatas.globalPathSearch, page, query)
end

LxsDatas.globalPosWallpaper = function(page, query)
  return string.format("%s?tt=9&countrycode=ID&vosSupportLockScreen=0&sysVer=PD2055D_A_1.10.5&locale=ID&sysromver=11&startIndex=%d&themetype=9&setId=-1&model=v2055A&lang=ID&pixel=3.0&apppkgName=com.bbk.theme&height=2400&romVer=4.2&mktprdmodel=v2055A&appversion=8.6.1.4&vos20=0&resId=&adrVerName=11&cfrom=503&cs=0&av=28&hots=%s&width=1080&immersiveBanner=true&appvercode=8614&promodel=PD2055D_A&category=9&",LxsDatas.globalPathSearch, page, query)
end


LxsDatas.cnPostTheme = function(page, query)
  return string.format("%s/api14.do?model=vivoX21A&mktprdmodel=vivoX21A&promodel=PD1728&imei=869704036083738&appversion=6.3.8.0&appvercode=6380&e=1234567890&apppkgName=com.bbk.theme&av=28&adrVerName=9&timestamp=1587482919020&pixel=3.0&cs=0&locale=zh_CN&themetype=1&elapsedtime=592960661&width=1080&height=2280&romVer=4.2&sysVer=PD1728_A_7.9.0&sysromver=9&tt=1&nightpearlResVersion=3.1.0&isShowClock=1&requestId=7048651e-4d95-49a8-a6a8-7bae98ad8471&requestTime=1587482919020&hots=%s&pageIndex=%d&setId=-1&flag=11&cfrom=819", LxsDatas.cnUrl, query, page)
end

LxsDatas.cnPostFonts = function(page, query)
  return string.format("%s/api14.do?model=vivoX21A&mktprdmodel=vivoX21A&promodel=PD1728&imei=869704036083738&appversion=6.3.8.0&appvercode=6380&e=1234567890&apppkgName=com.bbk.theme&av=28&adrVerName=9&timestamp=1587482919020&pixel=3.0&cs=0&locale=zh_CN&themetype=4&elapsedtime=592960661&width=1080&height=2280&romVer=4.2&sysVer=PD1728_A_7.9.0&sysromver=9&tt=4&nightpearlResVersion=3.1.0&isShowClock=1&requestId=7048651e-4d95-49a8-a6a8-7bae98ad8471&requestTime=1587482919020&hots=%s&pageIndex=%d&setId=-1&flag=11&cfrom=819", LxsDatas.cnUrl, query, page)
end

LxsDatas.cnPostWallpaper = function(page, query)
  return string.format("%s/api14.do?model=vivoX21A&mktprdmodel=vivoX21A&promodel=PD1728&imei=869704036083738&appversion=6.3.8.0&appvercode=6380&e=1234567890&apppkgName=com.bbk.theme&av=28&adrVerName=9&timestamp=1587482919020&pixel=3.0&cs=0&locale=zh_CN&themetype=9&elapsedtime=592960661&width=1080&height=2280&romVer=4.2&sysVer=PD1728_A_7.9.0&sysromver=9&tt=9&nightpearlResVersion=3.1.0&isShowClock=1&requestId=7048651e-4d95-49a8-a6a8-7bae98ad8471&requestTime=1587482919020&hots=%s&pageIndex=%d&setId=-1&flag=11&cfrom=819", LxsDatas.cnUrl, query, page)
end

LxsDatas.cnPostThemeDetail = function(packageId)
  return string.format("%s?packageId=%s&catagory=1", LxsDatas.cnPathDetails, packageId)
end

return LxsDatas