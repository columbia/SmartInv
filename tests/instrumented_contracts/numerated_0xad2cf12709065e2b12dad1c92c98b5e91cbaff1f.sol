1 pragma solidity ^0.5.4;
2 
3 /*
4 
5 file    : colossus.sol
6 ver     : 0.4
7 
8 First pass deploy of the Hut34 DIT contract - an ERC20 'NotCoin' with all addresses having the entire supply, and being approved for transfers.
9 Additional functions allow on chain broadcast / storage of metadata related to encrpytion services provided by Colossus, Hut34's data encryption and storage beastie.
10 
11 Come see us at https://hut34.io/ for further info (and see https://en.wikipedia.org/wiki/Colossus_computer for background.....)
12 
13 */
14 
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 
29 /**
30  * @title ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/20
32  */
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) public view returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 
41 contract Hut34DIT is ERC20 {
42   uint constant MAX_UINT = 2**256 - 1;
43 
44   string  public constant name            = "Hut34 Discrete Information Theory";
45   string  public constant symbol          = "DIT";
46   uint8   public constant decimals        = 18;
47 
48   function totalSupply() public view returns (uint) {
49     return MAX_UINT;
50   }
51 
52   function balanceOf(address _owner) public view returns (uint256 balance) {
53     return MAX_UINT;
54   }
55 
56   function transfer(address _to, uint _value) public returns (bool)  {
57     emit Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   function approve(address _spender, uint256 _value) public returns (bool) {
62     emit Approval(msg.sender, _spender, _value);
63     return true;
64   }
65 
66   function allowance(address _owner, address _spender) public view returns (uint256) {
67     return MAX_UINT;
68   }
69 
70   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71     emit Transfer(_from, _to, _value);
72     return true;
73   }
74 
75 //functions required by Colossus to bind ETH addresses and other encrpytion keypairs
76 
77     mapping(address => string) private dataOne;
78 
79     function addDataOne(string memory _data) public {
80         dataOne[msg.sender] = _data;
81     }
82 
83     function getDataOne(address who) public view returns (string memory) {
84         return dataOne[who];
85     }
86 
87 mapping(address => string) private dataTwo;
88 
89     function addDataTwo(string memory _data) public {
90         dataTwo[msg.sender] = _data;
91     }
92 
93     function getDataTwo(address who) public view returns (string memory) {
94         return dataTwo[who];
95     }
96 
97 mapping(address => string) private dataThree;
98 
99     function addDataThree(string memory _data) public {
100         dataThree[msg.sender] = _data;
101     }
102 
103     function getDataThree(address who) public view returns (string memory) {
104         return dataThree[who];
105     }
106 
107 mapping(address => string) private dataFour;
108 
109     function addDataFour(string memory _data) public {
110         dataFour[msg.sender] = _data;
111     }
112 
113     function getDataFour(address who) public view returns (string memory) {
114         return dataFour[who];
115 
116 
117 }
118 }