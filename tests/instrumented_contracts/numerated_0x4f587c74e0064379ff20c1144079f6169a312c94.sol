1 pragma solidity ^0.4.24;
2 
3 contract Tokens {
4     address public owner;
5     mapping(string => uint) supply; // Total supply of token named
6     mapping(string => mapping(address => uint)) balances;
7     uint public fee; // For creation
8 
9     constructor(uint _fee) public {
10         owner = msg.sender;
11         fee = _fee;
12     }
13 
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     // Safe math functions
20     function subtr(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function addit(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     // Create new token, supply is hard, be serious on internal
32     function mint(string _name, uint _supply) public payable {
33         require(msg.value >= fee); // Fee is prevents over create
34         require(supply[_name] == 0); // Protect from remint
35         supply[_name] = _supply;
36         balances[_name][msg.sender] = _supply;
37         emit Mint(_name, _supply);
38     }
39 
40     function transfer(string _name, address _to, uint _amount) external {
41         require(_amount <= balances[_name][msg.sender]);
42         balances[_name][msg.sender] = subtr(balances[_name][msg.sender], _amount);
43         balances[_name][_to] = addit(balances[_name][_to], _amount);
44         emit Transfer(_name, msg.sender, _to, _amount);
45     }
46 
47     function balanceOf(string _name, address _address) external view returns(uint) {
48         return balances[_name][_address];
49     }
50 
51     function supplyOf(string _name) external view returns(uint) {
52         return supply[_name];
53     }
54 
55     function setFee(uint _fee) external onlyOwner {
56         fee = _fee;
57     }
58 
59     // Withdraw fee to owner
60     function withdraw() external onlyOwner {
61         owner.transfer(address(this).balance);
62     }
63 
64     event Transfer(string indexed name, address indexed from, address indexed to, uint amount);
65     event Mint(string indexed name, uint supply);
66 }