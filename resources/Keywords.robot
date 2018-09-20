*** Settings ***
Library           Selenium2Library
Resource          Variables.txt
Resource          Values.txt
Resource          Keywords.robot
Library           HttpLibrary
Library           HttpLibrary.HTTP
Library           RequestsLibrary

*** Keywords ***
打开浏览器
    Open Browser    ${URL_Student}    ${Browser}
    sleep    5
    Maximize Browser Window

首页登录按钮
    wait until element is visible    ${SignIn_Css}
    Click Element    ${SignIn_Css}
    sleep    5

首页注册按钮
    wait until element is visible    ${SignUp_Css}
    Click Element    ${SignUp_Css}
    Sleep    5

输入用户名
    wait until element is visible    ${SignIn_Username}
    Input Text    ${SignIn_Username}    18500077016
    sleep    5

输入密码
    wait until element is visible    ${SignIn_password}
    Input Password    ${SignIn_password}    111111
    sleep    5

登录
    wait until element is visible    ${SignIn_Button}
    Click Element    ${SignIn_Button}
    sleep    5

个人主页
    Click Element    ${家长中心_个人主页}

预约课程
    Click Element    ${家长中心_预约课程}

Assert
    capture page screenshot

输入注册电话
    Maximize Browser Window
    wait until element is visible    ${SignUp_phonenum_xPath}
    Click Element    ${SignUp_phonenum_xPath}
    sleep    5
    Input Text    ${SignUp_phonenum_xPath}    10011111111
    sleep    5

输入孩子生日
    wait until element is visible    ${SignUP_Birthday}
    sleep    5
    Click Element    ${SignUP_Birthday}
    sleep    5
    comment    1996年
    Click Element    ${SignUp_data_year}
    sleep    5
    comment    3月
    Click Element    ${SignUp_data_month}
    sleep    5
    comment    6日
    Click Element    ${SignUp_data_data}
    sleep    5

输入孩子中文名
    Click Element    ${SignUp_Chinesename}
    Input Text    ${SignUp_Chinesename}    中文名
    Sleep    5

输入孩子英文名
    Click Element    ${SignUp_Englishname}
    Input Text    ${SignUp_Englishname}    Thomas
    Sleep    5

短信验证码
    Click Element    ${SignUp_number}
    Input Text    ${SignUp_number}    000000
    Sleep    5

设置密码
    Click Element    ${SignUp_Password}
    Input Text    ${SignUp_Password}    111111
    Sleep    5

渠道信息
    Click Element    ${SignUp_qudao}
    Input Text    ${SignUp_qudao}    111111
    Sleep    5

提交注册
    Click Element    css=.smt-button.smt-button-red

Token
    comment    us_user 是token名
    ${TeacherContent}    Get cookie value    ${cookiename}
    Log    ${TeacherContent}
    sleep    5
    ${JsonA}    Unquote    ${TeacherContent}
    Log    ${JsonA}
    ${TokenA}    Get Json Value    ${JsonA}    /token
    ${TokenB}    replace String    ${TokenA}    "    ${Empty}
    ${TokenC}    replace String    ${TokenB}    "    ${Empty}
    Log    ${TokenC}
    [Return]    ${TokenC}

约课确认点击
    Sleep    5
    Click Element    ${PopMakesure}
    Sleep    5
    Click Element    ${Successful}

约周一
    Click Element    ${MonPath}
    Sleep    5
    Click Element    ${MonPath}
    约课确认点击

约周二
    Click Element    ${TuePath}
    约课确认点击

约周三
    Click Element    ${WedPath}
    约课确认点击

约周四
    Click Element    ${ThuPath}
    约课确认点击

约周五
    Click Element    ${FriPath}
    约课确认点击

约周六
    Click Element    ${SatPath}
    约课确认点击

约周日
    Click Element    ${SunPath}
    约课确认点击

开课教师列表接口
    ${Token}    Token
    ${str1}    Catenate    SEPARATOR=    /teachers?    keywords=&
    ${str2}    Catenate    SEPARATOR=    ${str1}    startTime=1505059200&
    ${str4}    Catenate    SEPARATOR=    ${str2}    ${startTime}
    ${str5}    Catenate    SEPARATOR=    ${str4}    &endTime=1505664000&
    ${str6}    Catenate    SEPARATOR=    ${str5}    ${endTime}
    ${str7}    Catenate    SEPARATOR=    ${str6}    &duration=&favorite=0&finished=0&favailable=0&gender=0&page=1&pageSize=5&
    ${str8}    Catenate    SEPARATOR=    ${str7}    token=
    ${teacherlist}    Catenate    SEPARATOR=    ${str8}    ${Token}
    Log    ${teacherlist}
    [Return]    ${teacherlist}

教师开课信息接口
    ${Token}    Token
    ${str9}    Catenate    SEPARATOR=    /teacher/timeslot?    startTime=
    ${str10}    Catenate    SEPARATOR=    ${str9}    ${startTime}
    ${str11}    Catenate    SEPARATOR=    ${str10}    &endTime=
    ${str12}    Catenate    SEPARATOR=    ${str11}    ${endTime}
    ${str13}    Catenate    SEPARATOR=    ${str12}    &duration=&
    ${str14}    Catenate    SEPARATOR=    ${str13}    teacherId=42159&
    ${str15}    Catenate    SEPARATOR=    ${str14}    token=
    ${Classlist}    Catenate    SEPARATOR=    ${str15}    ${Token}
    Log    ${Classlist}
    [Return]    ${Classlist}

今日课程接口
    ${Token}    Token
    ${Todayinfo}    Catenate    SEPARATOR=    /statistic?token=    ${Token}
    Log    ${Todayinfo}
    ${URL}    RequestsLibrary.Get Request    api    ${Todayinfo}
    ${Feedback}    to json    ${URL.content}
    Log    ${Feedback['data']['currentLessonInfo']['id']}
    Run Keyword IF    ${Feedback['data']['currentLessonInfo']['id']}==${null}    Log
    ...    ELSE    Click Element    css=.smt-button.smt-button-fill-normal.smt-button-md

选择开课教师
    ${teacherlist}    开课教师列表接口
    ${OutPut}    RequestsLibrary.Get Request    api    ${teacherlist}
    ${OutPutA}    Convert To String    ${OutPut.content}
    Log    ${OutPutA}
    should contain    ${OutPutA}    "teacherId":42159    msg=There is no Terrisa
    Click Element    ${Teacher}

选择开课时间
    ${ClassList}    教师开课信息接口
    ${OutPutB}    RequestsLibrary.Get Request    api    ${ClassList}
    Log    ${OutPutB.content}
    ${OutPutJ}    to json    ${OutPutB.content}
    ${Length}    Get Length    ${OutPutJ['data']['rows']}
    Log    ${Length}
    : FOR    ${i}    IN RANGE    ${Length}
    \    Log many    ${OutPutJ['data']['rows'][${i}]['status']}    ${OutPutJ['data']['rows'][${i}]['startTime']}
    \    ${timeslot}    set variable    ${OutPutJ['data']['rows'][${i}]['startTime']}
    \    Run Keyword IF    ${timeslot}==${Mon}    约周一
    \    ...    ELSE IF    ${timeslot}==${Tue}    约周二
    \    ...    ELSE IF    ${timeslot}==${Wed}    约周三
    \    ...    ELSE IF    ${timeslot}==${Thu}    约周四
    \    ...    ELSE IF    ${timeslot}==${Fri}    约周五
    \    ...    ELSE IF    ${timeslot}==${Sat}    约周六
    \    ...    ELSE IF    ${timeslot}==${Sun}    约周日
    \    ...    ELSE    Log    There is no timeslot

Session建立
    Create Session    api    ${家长中心Session}

Session关闭
    Delete All Sessions
