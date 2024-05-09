1 pragma solidity ^0.8.4;
2 
3 contract Token {
4     mapping(address => uint) private balances;
5     mapping(address => mapping(address => uint)) private allowed;
6     uint public totalSupply;
7     string public name;
8     string public symbol;
9     uint public decimals;
10     
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13     
14     constructor(string memory _name, string memory _symbol, uint _dec, uint _supply, address _owner) {
15         name = _name;
16         symbol = _symbol;
17         decimals = _dec;
18         totalSupply = _supply * 10 ** decimals;
19         balances[_owner] = totalSupply;
20         emit Transfer(address(0), _owner, totalSupply);
21     }
22     
23     function balanceOf(address owner) public view returns(uint) {
24         return balances[owner];
25     }
26     
27     function transfer(address to, uint value) public returns(bool) {
28         require(balances[msg.sender] >= value, 'balance too low');
29         balances[to] += value;
30         balances[msg.sender] -= value;
31         emit Transfer(msg.sender, to, value);
32         return true;
33     }
34     
35     function transferFrom(address from, address to, uint value) public returns(bool) {
36         require(balances[from] >= value, 'balance too low');
37         require(allowed[from][msg.sender] >= value, 'allowance too low');
38         balances[to] += value;
39         balances[from] -= value;
40         allowed[from][msg.sender] -=value;
41         emit Transfer(from, to, value);
42         return true;   
43     }
44     
45     function approve(address spender, uint value) public returns (bool) {
46         allowed[msg.sender][spender] = value;
47         emit Approval(msg.sender, spender, value);
48         return true;   
49     }
50     
51     function allowance(address owner, address spender) public view returns (uint) {
52         return allowed[owner][spender];
53     }
54     
55 }