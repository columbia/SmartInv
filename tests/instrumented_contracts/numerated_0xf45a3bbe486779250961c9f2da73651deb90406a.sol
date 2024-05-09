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
53     function setAmount(address[] contributors, uint[] amounts) public onlyOwner {
54         for (uint256 i = 0; i < contributors.length; i++) {
55             tokensOwed[contributors[i]] = amounts[i];
56         }
57     }
58 
59     function withdrawAllTokens() public onlyOwner {
60         token.transfer(owner, token.balanceOf(address(this)));
61     }
62 
63     function() public payable {
64         collect();
65     }
66 
67     function collect() public {
68         uint amount = tokensOwed[msg.sender];
69         require(amount > 0);
70         tokensOwed[msg.sender] = 0;
71         token.transfer(msg.sender, amount);
72         AmountSent(msg.sender, amount);
73     }
74 }