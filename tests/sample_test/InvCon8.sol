1 pragma solidity ^0.5.0;


2 contract ERC20Interface {
3     function totalSupply() public view returns (uint);
4     function balanceOf(address tokenOwner) public view returns (uint balance);
5     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
6     function transfer(address to, uint tokens) public returns (bool success);
7     function approve(address spender, uint tokens) public returns (bool success);
8     function transferFrom(address from, address to, uint tokens) public returns (bool success);

9     event Transfer(address indexed from, address indexed to, uint tokens);
10     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
11 }


12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
19         c = a / b;
20     }
21 }


22 contract AlloHash is ERC20Interface, SafeMath {
23     string public name;
24     string public symbol;
25     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it

26     uint256 public _totalSupply;

27     mapping(address => uint) balances;
28     mapping(address => mapping(address => uint)) allowed;

  
29     constructor() public {
30         name = "AlloHash";
31         symbol = "ALH";
32         decimals = 18;
33         _totalSupply = 180000000000000000000000000;

34         balances[msg.sender] = _totalSupply;
35         emit Transfer(address(0), msg.sender, _totalSupply);
36     }

37     function totalSupply() public view returns (uint) {
38         return _totalSupply  - balances[address(0)];
39     }

40     function balanceOf(address tokenOwner) public view returns (uint balance) {
41         return balances[tokenOwner];
42     }

43     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
44         return allowed[tokenOwner][spender];
45     }

46     function approve(address spender, uint tokens) public returns (bool success) {
47         allowed[msg.sender][spender] = tokens;
48         emit Approval(msg.sender, spender, tokens);
49         return true;
50     }

51     function transfer(address to, uint tokens) public returns (bool success) {
52         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
53         balances[to] = safeAdd(balances[to], tokens);
54         emit Transfer(msg.sender, to, tokens);
55         return true;
56     }

57     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
58         balances[from] = safeSub(balances[from], tokens);
59         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
60         balances[to] = safeAdd(balances[to], tokens);
61         emit Transfer(from, to, tokens);
62         return true;
63     }
64 }