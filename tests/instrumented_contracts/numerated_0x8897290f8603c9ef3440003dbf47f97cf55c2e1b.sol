1 pragma solidity ^0.4.22;
2 contract Ownable {
3   address public owner;
4 
5   event OwnershipRenounced(address indexed previousOwner);
6   event OwnershipTransferred(
7     address indexed previousOwner,
8     address indexed newOwner
9   );
10 
11   /**
12    * @dev 可拥有的构造函数将合同的原始“所有者”设置为发送者
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev 如果由所有者以外的任何帐户调用，则抛出
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev 允许业主放弃合同的控制权.
29    */
30   function renounceOwnership() public onlyOwner {
31     emit OwnershipRenounced(owner);
32     owner = address(0);
33   }
34 
35   /**
36    * @dev 允许当前所有者将合同的控制转移给新所有者.
37    */
38   function transferOwnership(address _newOwner) public onlyOwner {
39     _transferOwnership(_newOwner);
40   }
41 
42   /**
43    * @dev 将合同的控制权移交给新所有者.
44    */
45   function _transferOwnership(address _newOwner) internal {
46     require(_newOwner != address(0));
47     emit OwnershipTransferred(owner, _newOwner);
48     owner = _newOwner;
49   }
50 }
51 
52 contract TokenMall is Ownable {
53   /**
54    * @dev 抵押物上链信息.
55    */
56   struct MortgageInfo {
57       bytes32 projectId;//项目ID 
58       string currency;//抵押币种 
59       string mortgageAmount;//抵押数量 
60       string releaseAmount;//释放数量 
61   }
62   mapping(bytes32 =>MortgageInfo) mInfo;
63   bytes32[] mortgageInfos;
64    
65   /**
66    * @dev 添加数据.
67    */
68     event MessageMintInfo(address sender,bool isScuccess,string message);
69     function mintMortgageInfo(string _projectId,string currency,string mortgageAmount,string releaseAmount) onlyOwner{
70         bytes32 proId = stringToBytes32(_projectId);
71         if(mInfo[proId].projectId != proId){
72               mInfo[proId].projectId = proId;
73               mInfo[proId].currency = currency;
74               mInfo[proId].mortgageAmount = mortgageAmount;
75               mInfo[proId].releaseAmount = releaseAmount;
76               mortgageInfos.push(proId);
77               MessageMintInfo(msg.sender, true,"添加成功");
78             return;
79         }else{
80              MessageMintInfo(msg.sender, false,"项目ID已经存在");
81             return;
82         }
83     }
84   /**
85    * @dev 更新数据.
86    */
87     event MessageUpdateInfo(address sender,bool isScuccess,string message);
88     function updateMortgageInfo(string _projectId,string releaseAmount) onlyOwner{
89          bytes32 proId = stringToBytes32(_projectId);
90         if(mInfo[proId].projectId == proId){
91               mInfo[proId].releaseAmount = releaseAmount;
92               mortgageInfos.push(proId);
93               MessageUpdateInfo(msg.sender, true,"修改成功");
94             return;
95         }else{
96              MessageUpdateInfo(msg.sender, false,"项目ID不存在");
97             return;
98         }
99     }
100      
101      
102   /**
103    * @dev 查询数据.
104    */
105     function getMortgageInfo(string _projectId) 
106     public view returns(string projectId,string currency,string mortgageAmount,string releaseAmount){
107          
108          bytes32 proId = stringToBytes32(_projectId);
109          
110          MortgageInfo memory mi = mInfo[proId];
111         
112         return (_projectId,mi.currency,mi.mortgageAmount,mi.releaseAmount);
113     }
114     
115      /// string类型转化为bytes32型转
116     function stringToBytes32(string memory source) constant internal returns(bytes32 result){
117         assembly{
118             result := mload(add(source,32))
119         }
120     }
121     /// bytes32类型转化为string型转
122     function bytes32ToString(bytes32 x) constant internal returns(string){
123         bytes memory bytesString = new bytes(32);
124         uint charCount = 0 ;
125         for(uint j = 0 ; j<32;j++){
126             byte char = byte(bytes32(uint(x) *2 **(8*j)));
127             if(char !=0){
128                 bytesString[charCount] = char;
129                 charCount++;
130             }
131         }
132         bytes memory bytesStringTrimmed = new bytes(charCount);
133         for(j=0;j<charCount;j++){
134             bytesStringTrimmed[j]=bytesString[j];
135         }
136         return string(bytesStringTrimmed);
137     }
138 
139 }