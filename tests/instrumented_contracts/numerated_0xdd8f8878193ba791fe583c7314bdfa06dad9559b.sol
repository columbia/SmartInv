1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 
8     
9     //function allowance(address tokenOwner, address spender) public view returns (uint remaining);
10     //function approve(address spender, uint tokens) public returns (bool success);
11     //function transferFrom(address from, address to, uint tokens) public returns (bool success);
12     
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 
18 contract ICTSLAB is ERC20Interface{
19     string public name = "ICTSLAB";
20     string public symbol = "ICT";
21     uint public decimals = 18;
22     
23     uint public supply;
24     address public founder;
25     
26     mapping(address => uint) public balances;
27 
28 
29  event Transfer(address indexed from, address indexed to, uint tokens);
30 
31 
32     constructor() public{
33         supply = 21000000000000000000000000;
34         founder = msg.sender;
35         balances[founder] = supply;
36     }
37     
38     
39     function totalSupply() public view returns (uint){
40         return supply;
41     }
42     
43     function balanceOf(address tokenOwner) public view returns (uint balance){
44          return balances[tokenOwner];
45      }
46      
47      
48     //transfer from the owner balance to another address
49     function transfer(address to, uint tokens) public returns (bool success){
50          require(balances[msg.sender] >= tokens && tokens > 0);
51          
52          balances[to] += tokens;
53          balances[msg.sender] -= tokens;
54          emit Transfer(msg.sender, to, tokens);
55          return true;
56      }
57      
58      
59      function burn(uint256 _value) public returns (bool success) {
60         require(balances[founder] >= _value);   // Check if the sender has enough
61         balances[founder] -= _value;            // Subtract from the sender
62         supply -= _value;                      // Updates totalSupply
63         return true;
64     }
65      
66 }