1 pragma solidity ^0.4.3;
2 
3 contract Avatars {
4     
5     uint avatarsCount = 0;
6 
7     struct Avatar {
8         uint id;
9         
10         /**
11          * Avatar's owner.
12          */ 
13         address owner;
14         
15         /**
16          * First byte is gender, 1 / 0 for male / female. 
17          * Then every byte describe choosen avatar part. 
18          * The order is : backs, clothes, ears, eyebrows, eyesfront, eyesiris, faceshape, glasses, hair, mouth, nose, beard, mustache. 
19          */ 
20         bytes32 shapes;
21         
22         /**
23          * Each 3 bytes describe color for 5 first shapes.
24          */
25         bytes32 colorsPrimary;
26         
27         /**
28          * Each 3 bytes describe color for 8 last shapes.
29          */
30         bytes32 colorsSecondary;
31         
32         /**
33          * Each byte describes up/down position for every shape. 
34          * High nibble depicts the sign of number, 1 - up, 0 - down.
35          * Low nibble shows number of steps to move the shape in selected direction.
36          * 
37          */
38         bytes32 positions;
39     }
40     
41     mapping(bytes32 => Avatar) avatars;
42     
43     /**
44      * Stores an avatar on the blockchain.
45      * Throws if avatar with such shapes combination is already exists.
46      * 
47      * @param shapes - hex string, depicts gender and combinations of shapes.
48      * @param colorsPrimary - hex string, colors of the first 5 shapes.
49      * @param colorsSecondary - hex string, colors of the last 8 shapes.
50      * @param positions - hex string, up/down positions of all shapes
51      * 
52      * @return Hash of the avatar.
53      */
54     function register(string shapes, string colorsPrimary, string colorsSecondary, string positions) returns (bytes32 avatarHash) {
55         bytes32 shapesBytes = strToBytes(shapes);
56         bytes32 colorsPrimaryBytes = strToBytes(colorsPrimary);
57         bytes32 colorsSecondaryBytes = strToBytes(colorsSecondary);
58         bytes32 positionsBytes = strToBytes(positions);
59 
60         // unique by shapes composition
61         bytes32 hash = sha3(shapes);
62 
63         Avatar memory existingAvatar = avatars[hash];
64         if (existingAvatar.id != 0)
65             throw;
66         
67         Avatar memory avatar = Avatar(++avatarsCount, msg.sender, 
68             shapesBytes,
69             colorsPrimaryBytes,
70             colorsSecondaryBytes,
71             positionsBytes);
72 
73         avatars[hash] = avatar;
74         return hash;
75     }
76     
77     /**
78      * Returns an avatar by it's hash.
79      * Throws if avatar is not exists.
80      */ 
81     function get(bytes32 avatarHash) constant returns (bytes32 shapes, bytes32 colorsPrimary, bytes32 colorsSecondary, bytes32 positions) {
82         Avatar memory avatar = getAvatar(avatarHash);
83         
84         shapes = avatar.shapes;
85         colorsPrimary = avatar.colorsPrimary;
86         colorsSecondary = avatar.colorsSecondary;
87         positions = avatar.positions;
88     }
89     
90     /**
91      * Returns an avatar owner address by avatar's hash.
92      * Throws if avatar is not exists.
93      */ 
94     function getOwner(bytes32 avatarHash) constant returns (address) {
95         Avatar memory avatar = getAvatar(avatarHash);
96         return avatar.owner;
97     }
98     
99         
100     /**
101      * Returns if avatar of the given hash exists.
102      */ 
103     function isExists(bytes32 avatarHash) constant returns (bool) {
104         Avatar memory avatar = avatars[avatarHash];
105         if (avatar.id == 0)
106             return false;
107             
108         return true;
109     }
110     
111     /**
112      * Returns an avatar by it's hash.
113      * Throws if avatar is not exists.
114      */ 
115     function getAvatar(bytes32 avatarHash) private constant returns (Avatar) {
116         Avatar memory avatar = avatars[avatarHash];
117         if (avatar.id == 0)
118            throw;
119            
120         return avatar;
121     }
122     
123     /**
124      * @dev Low level function.
125      * Converts string to bytes32 array.
126      * Throws if string length is more than 32 bytes
127      * 
128      * @param str string
129      * @return bytes32 representation of str
130      */
131     function strToBytes(string str) constant private returns (bytes32 ret) {
132         // var g = bytes(str).length;
133         // if (bytes(str).length > 32) throw;
134         
135         assembly {
136             ret := mload(add(str, 32))
137         }
138     } 
139 }