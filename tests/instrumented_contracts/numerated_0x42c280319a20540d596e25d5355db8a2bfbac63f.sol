1 pragma solidity ^0.4.24;
2 
3 // File: contracts\utils\NameFilter.sol
4 
5 library NameFilter {
6 
7     /**
8      * @dev filters name strings
9      * -converts uppercase to lower case.
10      * -makes sure it does not start/end with a space
11      * -makes sure it does not contain multiple spaces in a row
12      * -cannot be only numbers
13      * -cannot start with 0x
14      * -restricts characters to A-Z, a-z, 0-9, and space.
15      * @return reprocessed string in bytes32 format
16      */
17     function nameFilter(string _input)
18         internal
19         pure
20         returns(bytes32)
21     {
22         bytes memory _temp = bytes(_input);
23         uint256 _length = _temp.length;
24 
25         //sorry limited to 32 characters
26         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
27         // make sure it doesnt start with or end with space
28         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
29         // make sure first two characters are not 0x
30         if (_temp[0] == 0x30)
31         {
32             require(_temp[1] != 0x78, "string cannot start with 0x");
33             require(_temp[1] != 0x58, "string cannot start with 0X");
34         }
35 
36         // create a bool to track if we have a non number character
37         bool _hasNonNumber;
38 
39         // convert & check
40         for (uint256 i = 0; i < _length; i++)
41         {
42             // if its uppercase A-Z
43             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
44             {
45                 // convert to lower case a-z
46                 _temp[i] = byte(uint(_temp[i]) + 32);
47 
48                 // we have a non number
49                 if (_hasNonNumber == false)
50                     _hasNonNumber = true;
51             } else {
52                 require
53                 (
54                     // require character is a space
55                     _temp[i] == 0x20 ||
56                     // OR lowercase a-z
57                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
58                     // or 0-9
59                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
60                     "string contains invalid characters"
61                 );
62                 // make sure theres not 2x spaces in a row
63                 if (_temp[i] == 0x20)
64                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
65 
66                 // see if we have a character other than a number
67                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
68                     _hasNonNumber = true;
69             }
70         }
71 
72         require(_hasNonNumber == true, "string cannot be only numbers");
73 
74         bytes32 _ret;
75         assembly {
76             _ret := mload(add(_temp, 32))
77         }
78         return (_ret);
79     }
80 }
81 
82 // File: contracts\utils\Ownable.sol
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95 
96   /**
97    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98    * account.
99    */
100   constructor() public {
101     owner = msg.sender;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) public onlyOwner {
117     require(newOwner != address(0));
118     emit OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 
122 }
123 
124 // File: contracts\PlayerBook.sol
125 
126 contract PlayerBook is Ownable {
127     using NameFilter for string;
128 
129     uint256 public registrationFee_ = 10 finney;            // price to register a name
130     mapping (bytes32 => address) public nameToAddr;
131     mapping (address => string[]) public addrToNames;
132 
133     modifier isHuman() {
134         address _addr = msg.sender;
135         uint256 _codeLength;
136 
137         assembly {_codeLength := extcodesize(_addr)}
138         require(_codeLength == 0, "sorry humans only");
139         _;
140     }
141 
142 
143     function checkIfNameValid(string _nameStr) public view returns(bool) {
144       bytes32 _name = _nameStr.nameFilter();
145       if (nameToAddr[_name] == address(0))
146         return (true);
147       else
148         return (false);
149     }
150 
151     function getPlayerAddr(string _nameStr) public view returns(address) {
152       bytes32 _name = _nameStr.nameFilter();
153       return nameToAddr[_name];
154     }
155 
156     function getPlayerName() public view returns(string) {
157       address _addr = msg.sender;
158       string[] memory names = addrToNames[_addr];
159       return names[names.length-1];
160     }
161 
162     function registerName(string _nameString) public isHuman payable {
163       // make sure name fees paid
164       require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
165 
166       // filter name + condition checks
167       bytes32 _name = NameFilter.nameFilter(_nameString);
168       require(nameToAddr[_name] == address(0), "name must not be taken by others");
169       address _addr = msg.sender;
170       nameToAddr[_name] = _addr;
171       addrToNames[_addr].push(_nameString);
172     }
173 
174     function registerNameByOwner(string _nameString, address _addr) public onlyOwner {
175       bytes32 _name = NameFilter.nameFilter(_nameString);
176       require(nameToAddr[_name] == address(0), "name must not be taken by others");
177       nameToAddr[_name] = _addr;
178       addrToNames[_addr].push(_nameString);
179     }
180 
181 
182     function withdrawBalance(address _to) public onlyOwner {
183       uint _amount = address(this).balance;
184       _to.transfer(_amount);
185     }
186 }