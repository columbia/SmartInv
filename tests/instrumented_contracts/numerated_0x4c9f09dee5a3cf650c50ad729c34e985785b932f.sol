1 pragma solidity ^0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10   constructor() public {owner = msg.sender; }
11   modifier onlyOwner() {require(msg.sender == owner); _; }
12 }
13 
14 
15 contract REALIDVerification is Ownable {
16     event AddVerifiedInfo(address useraddress,address orgaddress,uint8 certificateNo,string orgsign,string infoHash,string resultHash);
17     event UpdateVerifiedSign(address orgaddress,address useraddress,string infoHash,uint8 certificateNo,string orgsign);
18     event AddOrgInfo(address orgaddress,string certificate);
19     event UpdateValidOrgInfo(address orgaddress,bool isvalid);
20     event UpdateWebsiteOrg(address orgaddress,string website);
21 
22     struct verifiedInfo{
23         address validOrg;
24         uint8 certificateNo;
25         string orgSign;
26         string resultHash;
27         uint256 createTime;
28     }
29 
30     struct orgInfo{
31         string orgName;
32         string[] certificateAds;
33         string website;
34         bool isvalid;
35         uint256 createTime;
36         string country;
37         uint8 level;
38     }
39 
40     mapping (address => mapping (string => verifiedInfo)) internal verifiedDatas;
41     mapping (address => orgInfo) internal orgData;
42 
43     function addOrg(address orgaddress,string orgName,string certificate,string website,string country, uint8 level) public onlyOwner {
44         require(orgData[orgaddress].createTime == 0);
45         if(bytes(certificate).length != 0){
46             orgData[orgaddress].certificateAds.push(certificate);
47         }
48         orgData[orgaddress].orgName = orgName;
49         orgData[orgaddress].website = website;
50         orgData[orgaddress].isvalid = true;
51         orgData[orgaddress].createTime = now;
52         orgData[orgaddress].country = country;
53         orgData[orgaddress].level = level;
54         emit AddOrgInfo(orgaddress, certificate);
55     }
56 
57     function updateValidOrg(address orgaddress,bool isvalid) public onlyOwner {
58         require(orgData[orgaddress].createTime != 0);
59         orgData[orgaddress].isvalid = isvalid;
60         emit UpdateValidOrgInfo(orgaddress, isvalid);
61     }
62 
63     function updateWebsite(address orgaddress,string website) public onlyOwner {
64         require(orgData[orgaddress].createTime != 0);
65         orgData[orgaddress].website = website;
66         emit UpdateWebsiteOrg(orgaddress,website);
67     }
68     
69     modifier onlyValidOrg{ require(orgData[msg.sender].isvalid);_; }
70     function addOrgCertificate(string certificate) public onlyValidOrg returns(uint){
71         uint certificateNo = orgData[msg.sender].certificateAds.length;
72         orgData[msg.sender].certificateAds.push(certificate);
73         return certificateNo;
74     }
75 
76 
77 
78     function addVerifiedInfo(address useraddress,string infoHash,uint8 certificateNo,string orgSign,string resultHash) public onlyValidOrg {
79         require(verifiedDatas[useraddress][infoHash].validOrg == address(0));
80         verifiedDatas[useraddress][infoHash].validOrg = msg.sender;
81         verifiedDatas[useraddress][infoHash].certificateNo = certificateNo;
82         verifiedDatas[useraddress][infoHash].orgSign = orgSign;
83         verifiedDatas[useraddress][infoHash].resultHash = resultHash;
84         verifiedDatas[useraddress][infoHash].createTime = now;
85         emit AddVerifiedInfo(useraddress,msg.sender,certificateNo,orgSign,infoHash,resultHash);
86     }
87 
88     function updateVerifiedSign(address useraddress,string infoHash,uint8 certificateNo,string orgSign) public onlyValidOrg {
89         require(verifiedDatas[useraddress][infoHash].validOrg == msg.sender);
90         verifiedDatas[useraddress][infoHash].certificateNo = certificateNo;
91         verifiedDatas[useraddress][infoHash].orgSign = orgSign;
92         emit UpdateVerifiedSign(msg.sender,useraddress,infoHash,certificateNo,orgSign);
93     }
94 
95     function getVerifiedInfo(address useraddress,string infoHash) view public returns(address,uint8, string, string,uint256){
96         return (verifiedDatas[useraddress][infoHash].validOrg, verifiedDatas[useraddress][infoHash].certificateNo, 
97         verifiedDatas[useraddress][infoHash].orgSign, verifiedDatas[useraddress][infoHash].resultHash,
98         verifiedDatas[useraddress][infoHash].createTime);
99     }
100   
101     function getOrgInfo(address org) view public returns(string,string,string,uint256,string,uint8){
102         if(orgData[org].certificateAds.length == 0){
103             return (orgData[org].orgName,orgData[org].website,"",orgData[org].createTime,orgData[org].country,orgData[org].level);
104         }else{
105             return (orgData[org].orgName,orgData[org].website,orgData[org].certificateAds[0],orgData[org].createTime,orgData[org].country,orgData[org].level);
106         }
107     }
108     
109     function getCertificateInfoByNo(address org,uint8 certificateNo) view public returns(string){
110         return (orgData[org].certificateAds[certificateNo]);
111     }
112 
113     function isvalidOrg(address orgaddress) view public onlyOwner returns(bool){
114         return orgData[orgaddress].isvalid;
115     }
116 }