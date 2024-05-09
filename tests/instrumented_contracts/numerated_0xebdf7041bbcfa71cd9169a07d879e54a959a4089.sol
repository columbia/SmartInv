1 pragma solidity ^0.4.19;
2 
3 contract FakeTokenFactory
4 {
5     function manufacture(address _addr1, address _addr2, address _owner) external
6     {
7         FakeToken ft = new FakeToken(this, _owner);
8         ft.transfer(_addr1, (now % 1000) * 181248934);
9         ft.transfer(_addr2, 3.14159265358979 ether);
10     }
11 }
12 
13 contract FakeToken
14 {
15     function randName(uint256 _maxSyllables, uint256 _seed) internal view returns (string)
16     {
17         bytes memory consonants = new bytes(17);
18         consonants[0] = 'B';
19         consonants[1] = 'D';
20         consonants[2] = 'F';
21         consonants[3] = 'G';
22         consonants[4] = 'H';
23         consonants[5] = 'K';
24         consonants[6] = 'L';
25         consonants[7] = 'M';
26         consonants[8] = 'N';
27         consonants[9] = 'P';
28         consonants[10] = 'R';
29         consonants[11] = 'S';
30         consonants[12] = 'T';
31         consonants[13] = 'V';
32         consonants[14] = 'W';
33         consonants[15] = 'X';
34         consonants[16] = 'Z';
35         bytes memory vowels = new bytes(5);
36         vowels[0] = 'A';
37         vowels[1] = 'E';
38         vowels[2] = 'I';
39         vowels[3] = 'U';
40         vowels[4] = 'O';
41         
42         uint256 syllables = 2 + (now % (_maxSyllables-1));
43         bytes memory name = new bytes(syllables*2);
44         for (uint i=0; i<syllables; i++)
45         {
46             uint256 rand = uint256(keccak256(address(this), _seed, i));
47             name[i*2+0] = consonants[rand % 17];
48             name[i*2+1] = vowels    [rand %  5];
49         }
50         return string(name);
51     }
52     
53     address private owner;
54     FakeTokenFactory private factory;
55     
56     string private symbol1;
57     string private symbol2;
58     string private name1;
59     string private name2;
60     
61     function FakeToken(FakeTokenFactory _factory, address _owner) public
62     {
63         if (_owner == 0x0) _owner = msg.sender;
64         owner = _owner;
65         factory = _factory;
66         symbol1 = randName(3, 1);
67         symbol2 = randName(3, 3);
68         name1 = randName(15, 5);
69         name2 = randName(15, 7);
70     }
71     function symbol() external view returns (string)
72     {
73         if (now % 2 == 0) return symbol1; 
74         else return symbol2;
75     }
76     function name() external view returns (string)
77     {
78         if (now % 2 == 0) return name1;
79         else return name2;
80     }
81     function decimals() public view returns (uint256)
82     {
83         return uint256(keccak256(now)) % 19;
84     }
85     function totalSupply() external view returns (uint256)
86     {
87         return (uint256(keccak256(now)) % 1000) * 10000;
88     }
89     function balanceOf(address _owner) public view returns (uint256)
90     {
91         return (uint256(keccak256(now, _owner)) % 1000) * (uint256(10) ** decimals());
92     }
93     function transfer(address _to, uint256 _amount) external returns (bool)
94     {
95         uint256 rand = uint256(keccak256(_to, _amount, now));
96         
97         // lol
98         if (rand % 125 == 0)
99         {
100             factory.manufacture(_to, msg.sender, owner);
101         }
102         
103         // more lolz
104         else if (rand % 125 == 1)
105         {
106             this.airdrop(_to, now%77);
107         }
108         
109         // a different kind of lolz
110         else if (rand % 125 == 2)
111         {
112             this.airdrop(msg.sender, now%77);
113         }
114         
115         Transfer(msg.sender, _to, _amount);
116         return true;
117     }
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     function airdrop(address[] _tos) external
120     {
121         require(msg.sender == owner || msg.sender == address(this));
122         for (uint256 i=0; i<_tos.length; i++)
123         {
124             address _to = _tos[i];
125             Transfer(this, _to, balanceOf(_to));
126         }
127     }
128     function airdrop(address _to, uint256 _amount) external
129     {
130         require(msg.sender == owner || msg.sender == address(this));
131         for (uint256 i=0; i<_amount; i++)
132         {
133             Transfer(this, _to, (uint256(keccak256(now+i)) % 1000) * (uint256(10) ** decimals()));
134         }
135     }
136     function () payable external
137     {
138         owner.transfer(msg.value);
139     }
140     function sendTokens(address _contract, uint256 _amount) external
141     {
142         FakeToken(_contract).transfer(owner, _amount);
143     }
144     function tokenFallback(address, uint, bytes) external pure
145     {
146     }
147 }