1 pragma solidity ^0.5.5;
2 
3 /*
4 
5 file    : colossus.sol
6 ver     : 0.4.2
7 
8 Deployment of Hut34's DIT contract - an ERC20 contract with all addresses having the entire supply, and being approved for transfers.
9 Additional functions allow on chain broadcast / storage of metadata related to encryption services provided by Colossus, Hut34's data encryption and storage beastie.
10 
11 Come see us at https://hut34.io/ for further info (and see https://en.wikipedia.org/wiki/Colossus_computer for background.....)
12 
13 Special thanks to OpenRelay's stateless contract "Notcoin" - https://blog.openrelay.xyz/notcoin/ :)
14 
15 */
16 
17 
18 /**
19  * @title ERC20Basic
20  * @dev Simpler version of ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/179
22  */
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 
31 /**
32  * @title ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/20
34  */
35 contract ERC20 is ERC20Basic {
36   function allowance(address owner, address spender) public view returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 
43 contract DITToken is ERC20 {
44   uint constant MAX_UINT = 2**256 - 1;
45 
46   string  public constant name            = "Discrete Information Theory";
47   string  public constant symbol          = "DIT";
48   uint8   public constant decimals        = 18;
49 
50   function totalSupply() public view returns (uint) {
51     return MAX_UINT;
52   }
53 
54   function balanceOf(address _owner) public view returns (uint256 balance) {
55     return MAX_UINT;
56   }
57 
58   function transfer(address _to, uint _value) public returns (bool)  {
59     emit Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   function approve(address _spender, uint256 _value) public returns (bool) {
64     emit Approval(msg.sender, _spender, _value);
65     return true;
66   }
67 
68   function allowance(address _owner, address _spender) public view returns (uint256) {
69     return MAX_UINT;
70   }
71 
72   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73     emit Transfer(_from, _to, _value);
74     return true;
75   }
76 
77 //functions required by Colossus to bind ETH addresses and other encrpytion keypairs
78 
79     mapping(address => string) private dataOne;
80 
81     function addDataOne(string memory _data) public {
82         dataOne[msg.sender] = _data;
83     }
84 
85     function getDataOne(address who) public view returns (string memory) {
86         return dataOne[who];
87     }
88 
89 mapping(address => string) private dataTwo;
90 
91     function addDataTwo(string memory _data) public {
92         dataTwo[msg.sender] = _data;
93     }
94 
95     function getDataTwo(address who) public view returns (string memory) {
96         return dataTwo[who];
97     }
98 
99 mapping(address => string) private dataThree;
100 
101     function addDataThree(string memory _data) public {
102         dataThree[msg.sender] = _data;
103     }
104 
105     function getDataThree(address who) public view returns (string memory) {
106         return dataThree[who];
107     }
108 
109 mapping(address => string) private dataFour;
110 
111     function addDataFour(string memory _data) public {
112         dataFour[msg.sender] = _data;
113     }
114 
115     function getDataFour(address who) public view returns (string memory) {
116         return dataFour[who];
117 }
118 
119 
120     event hutXTransfer(string IPFSHash, string txHash);
121 
122     function hutXTxComplete(string memory IPFSHash, string memory txHash) public returns (bool){
123         emit hutXTransfer(IPFSHash, txHash);
124         return true;
125     }
126 
127 }