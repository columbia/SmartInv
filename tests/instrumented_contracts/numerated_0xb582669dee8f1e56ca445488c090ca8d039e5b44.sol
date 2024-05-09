1 pragma solidity 0.4.25;
2 
3 interface Token {
4   function transfer(address _to, uint256 _value) external returns (bool);
5 }
6 
7 contract onlyOwner {
8   address public owner;
9   /** 
10   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11   * account.
12   */
13   constructor() public {
14     owner = msg.sender;
15   }
16   modifier isOwner {
17     require(msg.sender == owner);
18     _;
19   }
20 }
21 
22 contract Campaigns is onlyOwner{
23 
24   Token token;
25   event TransferredToken(address indexed to, uint256 value);
26   address distTokens;
27 
28   constructor(address _contract) public{
29       distTokens = _contract;
30       token = Token(_contract);
31   }
32   
33   function setTokenContract(address _contract) isOwner public{
34       distTokens = _contract;
35       token = Token(_contract);
36   } 
37   
38   function getTokenContract() public view returns(address){
39       return distTokens;
40   }
41 
42 
43     function sendResidualAmount(uint256 value) isOwner public returns(bool){
44         token.transfer(owner, value);
45         emit TransferredToken(msg.sender, value);
46         return true;
47     }    
48     
49     function sendAmount(address[] _user, uint256 value, uint256 decimal) isOwner public returns(bool){
50         require(_user.length <= 240);
51         for(uint i=0; i<= 240; i++)
52         token.transfer(_user[i], value*10**decimal);
53         return true;
54     }
55 	
56 	function sendIndividualAmount(address[] _user, uint256[] value, uint256 decimal) isOwner public returns(bool){
57 	    require(_user.length <= 240);
58         for(uint i=0; i<= 240; i++)
59         token.transfer(_user[i], value[i]*10**decimal);
60         return true;
61     }
62   
63 }