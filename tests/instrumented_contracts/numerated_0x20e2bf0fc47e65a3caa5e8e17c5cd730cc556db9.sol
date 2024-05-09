1 pragma solidity ^0.4.24;
2 
3 interface Token {
4   function transfer(address _to, uint256 _value) external returns (bool);
5 }
6 
7 contract onlyOwner {
8   address public owner;
9     bool private stopped = false;
10   /** 
11   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12   * account.
13   */
14   constructor() public {
15     owner = msg.sender;
16 
17   }
18     
19     modifier isRunning {
20         require(!stopped);
21         _;
22     }
23     
24     function stop() isOwner public {
25         stopped = true;
26     }
27 
28     function start() isOwner public {
29         stopped = false;
30     }
31   /**
32   * @dev Throws if called by any account other than the owner. 
33   */
34   modifier isOwner {
35     require(msg.sender == owner);
36     _;
37   }
38 }
39 
40 contract AirDrop is onlyOwner{
41 
42   Token token;
43 
44   event TransferredToken(address indexed to, uint256 value);
45 
46 
47   constructor() public{
48       address _tokenAddr = 0x99092a458b405fb8c06c5a3aa01cffd826019568; //here pass address of your token
49       token = Token(_tokenAddr);
50   }
51 
52     function() external payable{
53         withdraw();
54     }
55     
56     
57   function sendInternally(uint256 tokensToSend, uint256 valueToPresent) internal {
58     require(msg.sender != address(0));
59     token.transfer(msg.sender, tokensToSend);
60     emit TransferredToken(msg.sender, valueToPresent);
61     
62   }
63 
64   function withdraw() isRunning private returns(bool) {
65     sendInternally(400*10**18,400);
66     return true;   
67   }
68 }