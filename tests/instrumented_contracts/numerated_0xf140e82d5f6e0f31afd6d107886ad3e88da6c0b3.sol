1 pragma solidity ^0.4.24;
2  
3 contract Ownable {
4   address public owner;
5  
6   constructor() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 }
15 
16 interface Token {
17   function balanceOf(address _owner)  external  constant returns (uint256 );
18   function transfer(address _to, uint256 _value) external ;
19   event Transfer(address indexed _from, address indexed _to, uint256 _value);
20 }
21 
22 contract Airdropper is Ownable {
23     
24     function AirTransfer(address[] _recipients, uint256[] values, address _tokenAddress) onlyOwner public returns (bool) {
25         require(_recipients.length > 0);
26 
27         Token token = Token(_tokenAddress);
28         
29         for(uint j = 0; j < _recipients.length; j++){
30             token.transfer(_recipients[j], values[j]);
31         }
32  
33         return true;
34     }
35     
36     function AirTransfeSameToken(address[] _recipients, uint256 value, address _tokenAddress) onlyOwner public returns (bool) {
37         require(_recipients.length > 0);
38 
39         Token token = Token(_tokenAddress);
40         uint256 toSend = value * 10**18;
41         
42         for(uint j = 0; j < _recipients.length; j++){
43             token.transfer(_recipients[j], toSend);
44         }
45  
46         return true;
47     }
48     
49  
50      function withdrawalToken(address _tokenAddress) onlyOwner public { 
51         Token token = Token(_tokenAddress);
52         token.transfer(owner, token.balanceOf(this));
53     }
54 
55 }