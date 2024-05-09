1 pragma solidity ^0.4.20;
2 
3 // 定义ERC-20标准接口
4 contract ERC20Interface {
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint public totalSupply;
9 
10     function transfer(address to, uint tokens) public returns (bool success);
11     
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 contract ERC20Impl is ERC20Interface {
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) internal allowed;
23 
24     constructor() public {
25         name = "公益社区币";
26         symbol = "PWS"; 
27         decimals = 6;
28         totalSupply = 10000000 * 10 ** uint256(decimals);
29         balanceOf[msg.sender] = totalSupply;
30     }
31 
32     function transfer(address to, uint tokens) public returns (bool success) {
33         require(to != address(0));
34         require(balanceOf[msg.sender] >= tokens);
35         require(balanceOf[to] + tokens >= balanceOf[to]);
36 
37         balanceOf[msg.sender] -= tokens;
38         balanceOf[to] += tokens;
39         emit Transfer(msg.sender, to, tokens);
40     }
41 
42     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
43         require(to != address(0) && from != address(0));
44         require(balanceOf[from] >= tokens);
45         require(allowed[from][msg.sender] <= tokens);
46         require(balanceOf[to] + tokens >= balanceOf[to]);
47 
48         balanceOf[from] -= tokens;
49         balanceOf[to] += tokens;
50         emit Transfer(from, to, tokens);   
51 
52         success = true;
53     }
54 
55     function approve(address spender, uint tokens) public returns (bool success) {
56         allowed[msg.sender][spender] = tokens;
57         emit Approval(msg.sender, spender, tokens);
58 
59         success = true;
60     }
61 
62     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
63         return allowed[tokenOwner][spender];
64     }
65 }