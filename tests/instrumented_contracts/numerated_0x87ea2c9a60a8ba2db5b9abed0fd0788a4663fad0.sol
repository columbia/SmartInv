1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4 
5     /// @dev `owner` is the only address that can call a function with this
6     /// modifier
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     address public owner;
13 
14     /// @notice The Constructor assigns the message sender to be `owner`
15     function Owned() {
16         owner = msg.sender;
17     }
18 
19     address public newOwner;
20 
21     /// @notice `owner` can step down and assign some other address to this role
22     /// @param _newOwner The address of the new owner. 0x0 can be used to create
23     ///  an unowned neutral vault, however that cannot be undone
24     function changeOwner(address _newOwner) onlyOwner {
25         newOwner = _newOwner;
26     }
27 
28     function acceptOwnership() {
29         if (msg.sender == newOwner) {
30             owner = newOwner;
31         }
32     }
33 }
34 
35 contract ERC20Basic {
36     function transfer(address to, uint256 value) public returns (bool);
37     function balanceOf(address who) public constant returns (uint256);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract Distribute is Owned {
42 
43     mapping (address => uint) public tokensOwed;
44     ERC20Basic token;
45 
46     event AmountSet(address contributor, uint amount);
47     event AmountSent(address contributor, uint amount);
48 
49     function Distribute(address _token) public {
50         token = ERC20Basic(_token);
51     }
52 
53     function setAmount(address contributor, uint amount) public onlyOwner {
54         tokensOwed[contributor] = amount;
55     }
56 
57     function withdrawAllTokens() public onlyOwner {
58         token.transfer(owner, token.balanceOf(address(this)));
59     }
60 
61     function() public payable {
62         collect();
63     }
64 
65     function collect() public {
66         uint amount = tokensOwed[msg.sender];
67         require(amount > 0);
68         tokensOwed[msg.sender] = 0;
69         token.transfer(msg.sender, amount);
70         AmountSent(msg.sender, amount);
71     }
72 }