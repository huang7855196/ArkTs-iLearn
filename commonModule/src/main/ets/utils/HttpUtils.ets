import http from '@ohos.net.http'
import router from '@ohos.router'
import { BaseURL } from '../constants/Constants'
import { AuthorUtils } from './AuthorUtils'
import { LogUtils } from './LogUtils'

//发起http请求
const request = <T>(url: string, method: http.RequestMethod, params: object = {}) => {
  const req = http.createHttp()
  //配置请求头
  const options: http.HttpRequestOptions = {
    header: {
      'Content-Type': 'application/json'
    },
    readTimeout: 30000,
    method: method,
    extraData: http.HttpDataType.OBJECT
  }
  let fullUrl = BaseURL + url
  if (method === http.RequestMethod.GET) {
    const strArr = Object.keys(params).map(key => `${key}=${params[key]}`)
    if (strArr.length > 0) {
      fullUrl += `?${strArr.join('&')}`
    }
  } else {
    options.extraData = params
  }
  const user = AuthorUtils.getUser()
  if (user.token && options.header) {
    options.header['Authorization'] = `Bearer ${user.token}`
  }
  LogUtils.i(`REQUEST→${fullUrl}→${method} =>${JSON.stringify(params)}`)
  return req.request(fullUrl, options)
    .then((res) => {
      if (res.result) {
        LogUtils.i(`RESPONSE→${url}→${method} =>${res.result.toString().substring(0, 250)}`)
        const result = JSON.parse(res.result as string) as {
          code: number
          message: string
          data: T
        }
        if (result.code === 10000) {
          return result
        }
        if (result.code === 401) {
          AuthorUtils.delUser()
          router.pushUrl({
            url: 'pages/LoginPage'
          }, router.RouterMode.Single)
        }
      }
      return Promise.reject(res.result)
    })
    .catch((e) => {
      return Promise.reject(e)
    })
    .finally(() => {
      req.destroy()
    })
}
/*
 * @desc:请求工具类
 * @author:hxy
 * @date:2024/2/17
 */
export class HttpUtils {
  //GET请求
  static get<T>(url: string, params?: object) {
    return request<T>(url, http.RequestMethod.GET, params)
  }
  //POST请求
  static post<T>(url: string, params?: object) {
    return request<T>(url, http.RequestMethod.POST, params)
  }
  //PUT请求
  static put<T>(url: string, params?: object) {
    return request<T>(url, http.RequestMethod.PUT, params)
  }
  //PUT请求
  static delete<T>(url: string, params?: object) {
    return request<T>(url, http.RequestMethod.DELETE, params)
  }
}
