1 pragma solidity 0.4.25;
2 
3 interface COSS {
4   function sendTokens(address _destination, address _token, uint256 _amount) public;
5   function sendEther(address _destination, uint256 _amount) payable public;
6 }
7 
8 contract FSAContract{
9     address owner = 0xc17cbf9917ca13d5263a8d4069e566be23db1b09;
10     address cossContract = 0x9e96604445ec19ffed9a5e8dd7b50a29c899a10c;
11  
12      modifier onlyOwner(){
13         require(msg.sender == owner);
14         _;
15     }
16     
17     function sendTokens(address _destination, address _token, uint256 _amount) public onlyOwner {
18          COSS(cossContract).sendTokens(_destination,_token,_amount);
19     }
20     
21     function sendEther(address _destination, uint256 _amount) payable public onlyOwner {
22         COSS(cossContract).sendEther(_destination,_amount);
23     }
24 }