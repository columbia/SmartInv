1 pragma solidity ^0.4.18;
2 
3 contract KittyCoreInterface {
4     function cooAddress() public returns(address);
5 }
6 
7 /// @title GeneScience implements the trait calculation for new kitties
8 /// @author Axiom Zen, Dieter Shirley <dete@axiomzen.co> (https://github.com/dete), Fabiano P. Soriani <fabianosoriani@gmail.com> (https://github.com/flockonus), Jordan Schalm <jordan.schalm@gmail.com> (https://github.com/jordanschalm), Abhishek Chadha <abhishek@dapperlabs.com> (https://github.com/achadha235)
9 contract GeneScience {
10     bool public isGeneScience = true;
11 
12     uint256 internal constant maskLast8Bits = uint256(0xff);
13     uint256 internal constant maskFirst248Bits = uint256(~0xff);
14 
15     // This is the privileged birther address. If this is set to 0, privileged birthing is disabled
16     address internal _privilegedBirther;
17     // Privileged window size for birthers, set to 5 blocks.
18     uint256 public privilegedBirtherWindowSize = 5;
19     KittyCoreInterface _kittyCore;
20 
21     function GeneScience(address _privilegedBirtherAddress, address _kittyCoreAddress) public {
22         require(_kittyCoreAddress != address(0));
23         _kittyCore = KittyCoreInterface(_kittyCoreAddress);
24         _privilegedBirther = _privilegedBirtherAddress;
25     }
26 
27     /// @dev set the privileged birther address
28     /// @param _birtherAddress the new birther address
29     function setPrivilegedBirther(address _birtherAddress) public {
30         require(msg.sender == _kittyCore.cooAddress());
31         _privilegedBirther = _birtherAddress;
32     }
33 
34     /// @dev given a characteristic and 2 genes (unsorted) - returns > 0 if the genes ascended, that's the value
35     /// @param trait1 any trait of that characteristic
36     /// @param trait2 any trait of that characteristic
37     /// @param rand is expected to be a 3 bits number (0~7)
38     /// @return -1 if didnt match any ascention, OR a number from 0 to 30 for the ascended trait
39     function _ascend(uint8 trait1, uint8 trait2, uint256 rand) internal pure returns(uint8 ascension) {
40         ascension = 0;
41 
42         uint8 smallT = trait1;
43         uint8 bigT = trait2;
44 
45         if (smallT > bigT) {
46             bigT = trait1;
47             smallT = trait2;
48         }
49 
50         // https://github.com/axiomzen/cryptokitties/issues/244
51         if ((bigT - smallT == 1) && smallT % 2 == 0) {
52 
53             // The rand argument is expected to be a random number 0-7.
54             // 1st and 2nd tier: 1/4 chance (rand is 0 or 1)
55             // 3rd and 4th tier: 1/8 chance (rand is 0)
56 
57             // must be at least this much to ascend
58             uint256 maxRand;
59             if (smallT < 23) maxRand = 1;
60             else maxRand = 0;
61 
62             if (rand <= maxRand ) {
63                 ascension = (smallT / 2) + 16;
64             }
65         }
66     }
67 
68     /// @dev given a number get a slice of any bits, at certain offset
69     /// @param _n a number to be sliced
70     /// @param _nbits how many bits long is the new number
71     /// @param _offset how many bits to skip
72     function _sliceNumber(uint256 _n, uint256 _nbits, uint256 _offset) private pure returns (uint256) {
73         // mask is made by shifting left an offset number of times
74         uint256 mask = uint256((2**_nbits) - 1) << _offset;
75         // AND n with mask, and trim to max of _nbits bits
76         return uint256((_n & mask) >> _offset);
77     }
78 
79     /// @dev Get a 5 bit slice from an input as a number
80     /// @param _input bits, encoded as uint
81     /// @param _slot from 0 to 50
82     function _get5Bits(uint256 _input, uint256 _slot) internal pure returns(uint8) {
83         return uint8(_sliceNumber(_input, uint256(5), _slot * 5));
84     }
85 
86     /// @dev Parse a kitten gene and returns all of 12 "trait stack" that makes the characteristics
87     /// @param _genes kitten gene
88     /// @return the 48 traits that composes the genetic code, logically divided in stacks of 4, where only the first trait of each stack may express
89     function decode(uint256 _genes) public pure returns(uint8[]) {
90         uint8[] memory traits = new uint8[](48);
91         uint256 i;
92         for(i = 0; i < 48; i++) {
93             traits[i] = _get5Bits(_genes, i);
94         }
95         return traits;
96     }
97 
98     /// @dev Given an array of traits return the number that represent genes
99     function encode(uint8[] _traits) public pure returns (uint256 _genes) {
100         _genes = 0;
101         for(uint256 i = 0; i < 48; i++) {
102             _genes = _genes << 5;
103             // bitwise OR trait with _genes
104             _genes = _genes | _traits[47 - i];
105         }
106         return _genes;
107     }
108 
109     /// @dev return the expressing traits
110     /// @param _genes the long number expressing cat genes
111     function expressingTraits(uint256 _genes) public pure returns(uint8[12]) {
112         uint8[12] memory express;
113         for(uint256 i = 0; i < 12; i++) {
114             express[i] = _get5Bits(_genes, i * 4);
115         }
116         return express;
117     }
118 
119     /// @dev the function as defined in the breeding contract - as defined in CK bible
120     function mixGenes(uint256 _genes1, uint256 _genes2, uint256 _targetBlock) public returns (uint256) {
121         if (_privilegedBirther == address(0) || tx.origin == _privilegedBirther) {
122             // Allow immediate births if there is no privileged birther, or if the originator
123             // of the transaction is the privileged birther
124             require(block.number > _targetBlock);
125         } else {
126             require(block.number > _targetBlock + privilegedBirtherWindowSize);
127         }
128 
129 
130         // Try to grab the hash of the "target block". This should be available the vast
131         // majority of the time (it will only fail if no-one calls giveBirth() within 256
132         // blocks of the target block, which is about 40 minutes. Since anyone can call
133         // giveBirth() and they are rewarded with ether if it succeeds, this is quite unlikely.)
134         uint256 randomN = uint256(block.blockhash(_targetBlock));
135 
136         if (randomN == 0) {
137             // We don't want to completely bail if the target block is no-longer available,
138             // nor do we want to just use the current block's hash (since it could allow a
139             // caller to game the random result). Compute the most recent block that has the
140             // the same value modulo 256 as the target block. The hash for this block will
141             // still be available, and – while it can still change as time passes – it will
142             // only change every 40 minutes. Again, someone is very likely to jump in with
143             // the giveBirth() call before it can cycle too many times.
144             _targetBlock = (block.number & maskFirst248Bits) + (_targetBlock & maskLast8Bits);
145 
146             // The computation above could result in a block LARGER than the current block,
147             // if so, subtract 256.
148             if (_targetBlock >= block.number) _targetBlock -= 256;
149 
150             randomN = uint256(block.blockhash(_targetBlock));
151 
152             // DEBUG ONLY
153             // assert(block.number != _targetBlock);
154             // assert((block.number - _targetBlock) <= 256);
155             // assert(randomN != 0);
156         }
157 
158         // generate 256 bits of random, using as much entropy as we can from
159         // sources that can't change between calls.
160         randomN = uint256(keccak256(randomN, _genes1, _genes2, _targetBlock));
161         uint256 randomIndex = 0;
162 
163         uint8[] memory genes1Array = decode(_genes1);
164         uint8[] memory genes2Array = decode(_genes2);
165         // All traits that will belong to baby
166         uint8[] memory babyArray = new uint8[](48);
167         // A pointer to the trait we are dealing with currently
168         uint256 traitPos;
169         // Trait swap value holder
170         uint8 swap;
171         // iterate all 12 characteristics
172         for(uint256 i = 0; i < 12; i++) {
173             // pick 4 traits for characteristic i
174             uint256 j;
175             // store the current random value
176             uint256 rand;
177             for(j = 3; j >= 1; j--) {
178                 traitPos = (i * 4) + j;
179 
180                 rand = _sliceNumber(randomN, 2, randomIndex); // 0~3
181                 randomIndex += 2;
182 
183                 // 1/4 of a chance of gene swapping forward towards expressing.
184                 if (rand == 0) {
185                     // do it for parent 1
186                     swap = genes1Array[traitPos];
187                     genes1Array[traitPos] = genes1Array[traitPos - 1];
188                     genes1Array[traitPos - 1] = swap;
189 
190                 }
191 
192                 rand = _sliceNumber(randomN, 2, randomIndex); // 0~3
193                 randomIndex += 2;
194 
195                 if (rand == 0) {
196                     // do it for parent 2
197                     swap = genes2Array[traitPos];
198                     genes2Array[traitPos] = genes2Array[traitPos - 1];
199                     genes2Array[traitPos - 1] = swap;
200                 }
201             }
202 
203         }
204 
205         // DEBUG ONLY - We should have used 72 2-bit slices above for the swapping
206         // which will have consumed 144 bits.
207         // assert(randomIndex == 144);
208 
209         // We have 256 - 144 = 112 bits of randomness left at this point. We will use up to
210         // four bits for the first slot of each trait (three for the possible ascension, one
211         // to pick between mom and dad if the ascension fails, for a total of 48 bits. The other
212         // traits use one bit to pick between parents (36 gene pairs, 36 genes), leaving us
213         // well within our entropy budget.
214 
215         // done shuffling parent genes, now let's decide on choosing trait and if ascending.
216         // NOTE: Ascensions ONLY happen in the "top slot" of each characteristic. This saves
217         //  gas and also ensures ascensions only happen when they're visible.
218         for(traitPos = 0; traitPos < 48; traitPos++) {
219 
220             // See if this trait pair should ascend
221             uint8 ascendedTrait = 0;
222 
223             // There are two checks here. The first is straightforward, only the trait
224             // in the first slot can ascend. The first slot is zero mod 4.
225             //
226             // The second check is more subtle: Only values that are one apart can ascend,
227             // which is what we check inside the _ascend method. However, this simple mask
228             // and compare is very cheap (9 gas) and will filter out about half of the
229             // non-ascending pairs without a function call.
230             //
231             // The comparison itself just checks that one value is even, and the other
232             // is odd.
233             if ((traitPos % 4 == 0) && (genes1Array[traitPos] & 1) != (genes2Array[traitPos] & 1)) {
234                 rand = _sliceNumber(randomN, 3, randomIndex);
235                 randomIndex += 3;
236 
237                 ascendedTrait = _ascend(genes1Array[traitPos], genes2Array[traitPos], rand);
238             }
239 
240             if (ascendedTrait > 0) {
241                 babyArray[traitPos] = uint8(ascendedTrait);
242             } else {
243                 // did not ascend, pick one of the parent's traits for the baby
244                 // We use the top bit of rand for this (the bottom three bits were used
245                 // to check for the ascension itself).
246                 rand = _sliceNumber(randomN, 1, randomIndex);
247                 randomIndex += 1;
248 
249                 if (rand == 0) {
250                     babyArray[traitPos] = uint8(genes1Array[traitPos]);
251                 } else {
252                     babyArray[traitPos] = uint8(genes2Array[traitPos]);
253                 }
254             }
255         }
256 
257         return encode(babyArray);
258     }
259 }