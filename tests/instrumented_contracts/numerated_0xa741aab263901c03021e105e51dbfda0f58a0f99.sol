1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20 {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function transfer(address to, uint tokens) public returns (bool success);
26     event Transfer(address indexed from, address indexed to, uint tokens);
27    
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48 }
49 
50 contract Token is ERC20, Owned {
51     using SafeMath for uint;
52 
53     string public symbol;
54     string public  name;
55     uint8 public decimals;
56     uint _totalSupply;
57 
58     mapping(address => uint) balances;
59     event Transfer(address indexed from, address indexed to, uint256 tokens);
60  
61 
62 
63     constructor() public {
64         symbol = "HTK";
65         name = "House Token";
66         decimals = 18;
67         _totalSupply = 1000000 * 10 ** uint(decimals);
68         balances[owner] = _totalSupply;
69         emit Transfer(address(0), owner, _totalSupply);
70     }
71 
72     function totalSupply() public view returns (uint) {
73         return _totalSupply.sub(balances[address(0)]);
74     }
75 
76     function balanceOf(address tokenOwner) public view returns (uint balance) {
77         return balances[tokenOwner];
78     }
79    
80     function transfer(address to, uint tokens) public returns (bool success)
81     {
82         balances[msg.sender] = balances[msg.sender].sub(tokens);
83         balances[to] = balances[to].add(tokens);
84         emit Transfer(msg.sender, to, tokens);
85         return true;
86     }
87 }