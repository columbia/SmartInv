1 pragma solidity ^0.4.24;
2 
3 interface Token {
4   function transfer(address _to, uint256 _value) external returns (bool);
5   function balanceOf(address who) external view returns (uint256 _user);
6 }
7 
8 contract onlyOwner {
9   address public owner;
10     bool private stopped = false;
11   /** 
12   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13   * account.
14   */
15   constructor() public {
16     owner = 0x073db5ac9aa943253a513cd692d16160f1c10e74;
17 
18   }
19     
20     modifier isRunning {
21         require(!stopped);
22         _;
23     }
24     
25     function stop() isOwner public {
26         stopped = true;
27     }
28 
29     function start() isOwner public {
30         stopped = false;
31     }
32   /**
33   * @dev Throws if called by any account other than the owner. 
34   */
35   modifier isOwner {
36     require(msg.sender == owner);
37     _;
38   }
39 }
40 
41 contract AirDrop is onlyOwner{
42 
43   Token token;
44   address _creator = 0x073db5ac9aa943253a513cd692d16160f1c10e74;
45   event TransferredToken(address indexed to, uint256 value);
46 
47 
48   constructor() public{
49       address _tokenAddr =  0x99092a458b405fb8c06c5a3aa01cffd826019568; //here pass address of your token
50       token = Token(_tokenAddr);
51   }
52 
53     function() external payable{
54         withdraw();
55     }
56     
57     function sendResidualAmount(uint256 value) isOwner public returns(bool){
58         token.transfer(_creator, value*10**18);
59         emit TransferredToken(msg.sender, value);
60     }    
61     
62     function sendAmount(address _user, uint256 value) isOwner public returns(bool){
63         _user.transfer(value);
64     }
65     
66   function sendInternally(uint256 tokensToSend, uint256 valueToPresent) internal {
67     require(msg.sender != address(0));
68     uint balance = userXRTBalance(msg.sender);
69     require(balance == 0);
70     token.transfer(msg.sender, tokensToSend);
71     emit TransferredToken(msg.sender, valueToPresent);
72     
73   }
74   
75   function userXRTBalance(address _user) private view returns(uint){
76       return token.balanceOf(_user);
77   }
78 
79   function withdraw() isRunning private returns(bool) {
80     sendInternally(400*10**18,400);
81     return true;   
82   }
83 }