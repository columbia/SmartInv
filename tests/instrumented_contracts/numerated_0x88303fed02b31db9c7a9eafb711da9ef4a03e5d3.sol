1 contract NDCoinERC20 {
2 
3     event Transfer(address indexed from, address indexed to, uint tokens);
4     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
5     event Burn(address indexed tokenOwner, uint tokens);
6 
7     string public constant name = "Ziktalk";
8     string public constant symbol = "ZIK";
9     uint8 public constant decimals = 18;
10 
11     mapping(address => uint256) balances;
12 
13     mapping(address => mapping (address => uint256)) allowed;
14 
15     uint256 totalSupply_;
16 
17     constructor(uint256 total) {
18       totalSupply_ = total;
19       balances[msg.sender] = totalSupply_;
20     }
21 
22     function totalSupply() public view returns (uint256) {
23       return totalSupply_;
24     }
25 
26     function balanceOf(address tokenOwner) public view returns (uint) {
27         return balances[tokenOwner];
28     }
29 
30     function transfer(address receiver, uint numTokens) public returns (bool) {
31         require(numTokens <= balances[msg.sender]);
32         balances[msg.sender] -= numTokens;
33         balances[receiver] += numTokens;
34         emit Transfer(msg.sender, receiver, numTokens);
35         return true;
36     }
37 
38     function approve(address delegate, uint numTokens) public returns (bool) {
39         allowed[msg.sender][delegate] = numTokens;
40         emit Approval(msg.sender, delegate, numTokens);
41         return true;
42     }
43 
44     function allowance(address owner, address delegate) public view returns (uint) {
45         return allowed[owner][delegate];
46     }
47 
48     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
49         require(numTokens <= balances[owner]);
50         require(numTokens <= allowed[owner][msg.sender]);
51 
52         balances[owner] -= numTokens;
53         allowed[owner][msg.sender] -= numTokens;
54         balances[buyer] += numTokens;
55         emit Transfer(owner, buyer, numTokens);
56         return true;
57     }
58 
59     function burn(uint256 _value) public returns (bool) {
60         // Requires that the message sender has enough tokens to burn
61         require(_value <= balances[msg.sender]);
62 
63         // Subtracts _value from callers balance and total supply
64         balances[msg.sender] = balances[msg.sender] - _value;
65         totalSupply_ = totalSupply_ - _value;
66 
67         // Emits burn and transfer events, make sure you have them in your contracts
68         emit Burn(msg.sender, _value);
69         emit Transfer(msg.sender, address(0),_value);
70 
71         // Since you cant actually burn tokens on the blockchain, sending to address 0, which none has the private keys to, removes them from the circulating supply
72         return true;
73     }
74 }