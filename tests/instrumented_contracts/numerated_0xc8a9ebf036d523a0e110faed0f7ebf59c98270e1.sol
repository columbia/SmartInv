1 pragma solidity ^0.4.18;
2 
3 /*
4 项目：以太世界信息链项目，商贸信息网
5 时间：2018-03-23
6  */
7 
8 contract gradeinfo{
9     struct ProjectData{
10        string Descript;          //项目描述
11        address dapp_address;     //项目地址（ENS域名，或者42位以太坊项目合约地址）
12        string dapp_ens;
13        string dapp_jsoninfo;     //项目ABI json信息
14        address Owner;            //项目持有者钱包地址
15     }
16     
17     mapping(string => ProjectData) ProjectDatas;
18     address creater;                
19     string  public PlatformInformation=""; 
20     string  public Hotlist;                
21     string[] public AllProjectList; 
22 
23     //event loginfo(string title,string info);
24 
25     modifier OnlyCreater() { // Modifier
26         require(msg.sender == creater);
27         //if (msg.sender != creater) return;
28         _;
29     }   
30     
31     function gradeinfo() public {
32         creater=msg.sender;
33     }
34     
35     //查询一个项目名称是否已经存在,true-存在,false-不存在
36     function __FindProjects(string ProjectName) constant private returns(bool r) {
37         if(bytes(ProjectName).length==0) return false;
38         if(bytes(ProjectDatas[ProjectName].Descript).length==0) return false;
39         return true;
40     }
41     
42     /*
43     创建一个新项目
44     */   
45     function InsertProject(string ProjectName,string Descript,address dapp_address,string dapp_ens,string dapp_jsoninfo,address OwnerAddress) OnlyCreater public 
46     {
47         if(__FindProjects(ProjectName)==false){
48             if(bytes(Descript).length!=0) {
49                 ProjectDatas[ProjectName].Descript = Descript;
50             }else{
51                 ProjectDatas[ProjectName].Descript = ProjectName;
52             }
53             ProjectDatas[ProjectName].dapp_address = dapp_address;
54             ProjectDatas[ProjectName].dapp_ens = dapp_ens;
55             ProjectDatas[ProjectName].dapp_jsoninfo = dapp_jsoninfo;
56             ProjectDatas[ProjectName].Owner = OwnerAddress;
57             
58             AllProjectList.push(ProjectName);
59         }else{
60             //loginfo(NewProjectName,"项目已存在");
61         }
62     }
63     
64     /*
65     删除项目信息
66     */
67     function DeleteProject(string ProjectName) OnlyCreater public{
68         delete ProjectDatas[ProjectName];
69         uint len = AllProjectList.length; 
70         for(uint index=0;index<len;index++){
71            if(keccak256(ProjectName)==keccak256(AllProjectList[index])){
72                if(index==0){
73                     AllProjectList.length = 0;   
74                }else{
75                     for(uint i=index;i<len-1;i++){
76                         AllProjectList[i] = AllProjectList[i+1];
77                     }
78                     delete AllProjectList[len-1]; 
79                     AllProjectList.length--;
80                }
81                break; 
82            } 
83         }
84     }
85 
86 
87     function SetDescript(string ProjectName,string Descript) OnlyCreater public 
88     {
89         if(__FindProjects(ProjectName)==true){
90             if(bytes(Descript).length!=0) {
91                 ProjectDatas[ProjectName].Descript = Descript;
92             }else{
93                 ProjectDatas[ProjectName].Descript = ProjectName;
94             }
95         }
96     }
97 
98     function SetDappinfo(string ProjectName,address dapp_address,string dapp_ens,string dapp_jsoninfo) OnlyCreater public 
99     {
100         if(__FindProjects(ProjectName)==true){
101             ProjectDatas[ProjectName].dapp_address = dapp_address;
102             ProjectDatas[ProjectName].dapp_ens = dapp_ens;
103             ProjectDatas[ProjectName].dapp_jsoninfo = dapp_jsoninfo;
104         }
105     }
106 
107     function SetOwner(string ProjectName,address Owner) OnlyCreater public 
108     {
109         if(__FindProjects(ProjectName)==true){
110             ProjectDatas[ProjectName].Owner = Owner;
111         }
112     }
113 
114     /*
115     设置Hotlists推荐项目列表
116     */
117     function SetHotLists(string Hotlists)  OnlyCreater public {
118         Hotlist = Hotlists;
119     }
120     
121     /*
122     修改平台介绍
123     */
124     function SetPlatformInformation(string Info) OnlyCreater public{
125         PlatformInformation=Info;
126     }
127 
128     //kill this
129     function KillContract() OnlyCreater public{
130         selfdestruct(creater);
131     }
132     
133 
134     //查询一个项目名称是否已经存在
135     function GetDescript(string ProjectName) constant public returns(string) {
136         if(__FindProjects(ProjectName)==true){
137             return (ProjectDatas[ProjectName].Descript);
138         }else{
139            return (""); 
140         }
141     }
142     
143     function GetDappinfo(string ProjectName) constant public returns(address,string,string) {
144         if(__FindProjects(ProjectName)==true){
145             return (ProjectDatas[ProjectName].dapp_address,ProjectDatas[ProjectName].dapp_ens,ProjectDatas[ProjectName].dapp_jsoninfo);
146         }else{
147            return (0,"",""); 
148         }
149     }
150 
151     function GetOwner(string ProjectName) constant public returns(string,address){
152         if(__FindProjects(ProjectName)==true){
153             return ("项目提供者",ProjectDatas[ProjectName].Owner); 
154         }else{
155             return ("",0);
156         }
157     }
158 
159 }