1 pragma solidity ^0.4.22;
2 contract Ownable {
3     //tokenid属性 
4   struct VowInfo {
5       bytes32 tokenId;//Id
6       string sign;//签名 
7       string content;//内容 
8       string time;//时间
9   }
10   mapping(bytes32 =>VowInfo) vowInfoToken;
11   bytes32[] vowInfos;
12     /**
13     * 添加许愿 
14    */
15     event NewMerchant(address sender,bool isScuccess,string message);
16     function addVowInfo(bytes32 _tokenId,string sign,string content,string time) public {
17         if(vowInfoToken[_tokenId].tokenId != _tokenId){
18              vowInfoToken[_tokenId].tokenId = _tokenId;
19               vowInfoToken[_tokenId].sign = sign;
20               vowInfoToken[_tokenId].content = content;
21               vowInfoToken[_tokenId].time = time;
22               vowInfos.push(_tokenId);
23               NewMerchant(msg.sender, true,"添加成功");
24             return;
25         }else{
26              NewMerchant(msg.sender, false,"许愿ID已经存在");
27             return;
28         }
29     }
30      /**
31     * 返回 tokenId属性 
32    */
33     function getVowInfo(bytes32 _tokenId)public view returns(string tokenId,string sign,string content,string time){
34                 
35          VowInfo memory vow = vowInfoToken[_tokenId];
36         string memory vowId = bytes32ToString(vow.tokenId);
37         return (vowId,vow.sign,vow.content,vow.time);
38     }
39     
40     function bytes32ToString(bytes32 x) constant internal returns(string){
41         bytes memory bytesString = new bytes(32);
42         uint charCount = 0 ;
43         for(uint j = 0 ; j<32;j++){
44             byte char = byte(bytes32(uint(x) *2 **(8*j)));
45             if(char !=0){
46                 bytesString[charCount] = char;
47                 charCount++;
48             }
49         }
50         bytes memory bytesStringTrimmed = new bytes(charCount);
51         for(j=0;j<charCount;j++){
52             bytesStringTrimmed[j]=bytesString[j];
53         }
54         return string(bytesStringTrimmed);
55     }
56 }