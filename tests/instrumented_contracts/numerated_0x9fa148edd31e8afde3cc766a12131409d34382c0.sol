1 pragma solidity ^0.4.19;
2 
3 contract MINTY {
4     string public name = 'MINTY';
5     string public symbol = 'MINTY';
6     uint8 public decimals = 18;
7     uint public totalSupply = 10000000000000000000000000;
8     uint public minted = totalSupply / 5;
9     uint public minReward = 1000000000000000000;
10     uint public fee = 700000000000000;
11     uint public reducer = 1000;
12     uint private randomNumber;
13     address public owner;
14     uint private ownerBalance;
15     
16     /* This creates an array with all balances */
17     mapping (address => uint256) public balanceOf;
18     mapping (address => uint256) public successesOf;
19     mapping (address => uint256) public failsOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     
22     /* This generates a public event on the blockchain that will notify clients */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     
25     modifier onlyOwner {
26         if (msg.sender != owner) revert();
27         _;
28     }
29     
30     function transferOwnership(address newOwner) external onlyOwner {
31         owner = newOwner;
32     }
33     
34     /* Initializes contract with initial supply tokens to the creator of the contract */
35     function MINTY() public {
36         owner = msg.sender;
37         balanceOf[owner] = minted;
38         balanceOf[this] = totalSupply - balanceOf[owner];
39     }
40     
41     /* Internal transfer, only can be called by this contract */
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52     
53     /* Send coins */
54     function transfer(address _to, uint256 _value) external {
55         _transfer(msg.sender, _to, _value);
56     }
57     
58     /* Transfer tokens from other address */
59     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
60         require(_value <= allowance[_from][msg.sender]);     // Check allowance
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65     
66     /* Set allowance for other address */
67     function approve(address _spender, uint256 _value) external returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71     
72     function withdrawEther() external onlyOwner {
73         owner.transfer(ownerBalance);
74         ownerBalance = 0;
75     }
76     
77     function () external payable {
78         if (msg.value == fee) {
79             randomNumber += block.timestamp + uint(msg.sender);
80             uint minedAtBlock = uint(block.blockhash(block.number - 1));
81             uint minedHashRel = uint(sha256(minedAtBlock + randomNumber + uint(msg.sender))) % 10000000;
82             uint balanceRel = balanceOf[msg.sender] * 1000 / minted;
83             if (balanceRel >= 1) {
84                 if (balanceRel > 255) {
85                     balanceRel = 255;
86                 }
87                 balanceRel = 2 ** balanceRel;
88                 balanceRel = 5000000 / balanceRel;
89                 balanceRel = 5000000 - balanceRel;
90                 if (minedHashRel < balanceRel) {
91                     uint reward = minReward + minedHashRel * 1000 / reducer * 100000000000000;
92                     _transfer(this, msg.sender, reward);
93                     minted += reward;
94                     successesOf[msg.sender]++;
95                 } else {
96                     Transfer(this, msg.sender, 0);
97                     failsOf[msg.sender]++;
98                 }
99                 ownerBalance += fee;
100                 reducer++;
101             } else {
102                 revert();
103             }
104         } else {
105             revert();
106         }
107     }
108 }