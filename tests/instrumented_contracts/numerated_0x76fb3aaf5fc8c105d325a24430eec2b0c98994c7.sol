1 pragma solidity ^0.4.24;
2 
3 // DO YOU HATE EOS?
4 // LETS SUMMARIZE EOS
5 // > CENTRALIZED COIN 
6 // > CAN SEIZE FUNDS 
7 // > CAN REVERSE TX 
8 // CALLING IT NOW: EOS WILL KILL EXCHANGES BY REVERSING TX'S AT SOME POINT 
9 // AND EOS WILL BE SUSCEPTIBLE TO SCAM PEOPLE WHO CLAIM THEIR EOS IS STOLEN, WHILE THEY STOLE IT THEMSELVES 
10 // UPLOAD YOUR REASON WHY YOU HATE EOS AND GET FREE EOSHATE TOKENS! 
11 // (also check the Transfer address in the IHateEos function)
12 
13 contract EOSHate {
14 
15     string public name = "EOSHate";      //  token name
16     string public symbol = "EOSHate";           //  token symbol
17     uint256 public decimals = 18;            //  token digit
18 
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21     
22     mapping (uint => bool) public EosHaters;
23     
24 
25     uint256 public totalSupply = 0;
26 
27     modifier validAddress {
28         assert(0x0 != msg.sender);
29         _;
30     }
31     
32     // MINE YOUR OWN EOSHATE FUNCTIONS!!
33     // DIFFICULTY ALWAYS... 0! (but it will rise slightly because you cannot mine strings which other people submitted, or you just found a hash collission!!)
34     
35     function IHateEos(string reason) public {
36         uint hash = uint(keccak256(bytes(reason)));
37         if (!EosHaters[hash]){
38             // congratulations we found new hate for EOS!
39             // reward: an eos hate token 
40             EosHaters[hash] = true; 
41             balanceOf[msg.sender] += (10 ** 18);
42             emit Transfer(0xe05dEadE05deADe05deAde05dEADe05dEeeEAAAd, msg.sender, 10**18); // kek 
43             emit NewEOSHate(msg.sender, reason);
44             totalSupply += (10 ** 18); // CANNOT OVERFLOW THIS BECAUSE WE ONLY HAVE UINT HASHES (HACKERS BTFO)
45         }
46     }
47 
48     function transfer(address _to, uint256 _value) public validAddress returns (bool success) {
49         require(balanceOf[msg.sender] >= _value);
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         balanceOf[msg.sender] -= _value;
52         balanceOf[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public validAddress returns (bool success) {
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60         require(allowance[_from][msg.sender] >= _value);
61         balanceOf[_to] += _value;
62         balanceOf[_from] -= _value;
63         allowance[_from][msg.sender] -= _value;
64         emit Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public validAddress returns (bool success) {
69         require(_value == 0 || allowance[msg.sender][_spender] == 0);
70         allowance[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77     event NewEOSHate(address who, string reason);
78 }