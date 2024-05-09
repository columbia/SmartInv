1 pragma solidity ^0.4.18;
2 
3 
4 
5 /// @title GeneScience implements the trait calculation for new kitties
6 /// @author Axiom Zen, Dieter Shirley <dete@axiomzen.co> (https://github.com/dete), Fabiano P. Soriani <fabianosoriani@gmail.com> (https://github.com/flockonus), Jordan Schalm <jordan.schalm@gmail.com> (https://github.com/jordanschalm)
7 contract GeneScience {
8     bool public isGeneScience = true;
9 
10     uint256 internal constant maskLast8Bits = uint256(0xff);
11     uint256 internal constant maskFirst248Bits = uint256(~0xff);
12 
13     function GeneScience() public {}
14 
15     /// @dev given a characteristic and 2 genes (unsorted) - returns > 0 if the genes ascended, that's the value
16     /// @param trait1 any trait of that characteristic
17     /// @param trait2 any trait of that characteristic
18     /// @param rand is expected to be a 3 bits number (0~7)
19     /// @return -1 if didnt match any ascention, OR a number from 0 to 30 for the ascended trait
20     function _ascend(uint8 trait1, uint8 trait2, uint256 rand) internal pure returns(uint8 ascension) {
21         ascension = 0;
22 
23         uint8 smallT = trait1;
24         uint8 bigT = trait2;
25 
26         if (smallT > bigT) {
27             bigT = trait1;
28             smallT = trait2;
29         }
30 
31         // https://github.com/axiomzen/cryptokitties/issues/244
32         if ((bigT - smallT == 1) && smallT % 2 == 0) {
33 
34             // The rand argument is expected to be a random number 0-7.
35             // 1st and 2nd tier: 1/4 chance (rand is 0 or 1)
36             // 3rd and 4th tier: 1/8 chance (rand is 0)
37 
38             // must be at least this much to ascend
39             uint256 maxRand;
40             if (smallT < 23) maxRand = 1;
41             else maxRand = 0;
42 
43             if (rand <= maxRand ) {
44                 ascension = (smallT / 2) + 16;
45             }
46         }
47     }
48 
49     /// @dev given a number get a slice of any bits, at certain offset
50     /// @param _n a number to be sliced
51     /// @param _nbits how many bits long is the new number
52     /// @param _offset how many bits to skip
53     function _sliceNumber(uint256 _n, uint256 _nbits, uint256 _offset) private pure returns (uint256) {
54         // mask is made by shifting left an offset number of times
55         uint256 mask = uint256((2**_nbits) - 1) << _offset;
56         // AND n with mask, and trim to max of _nbits bits
57         return uint256((_n & mask) >> _offset);
58     }
59 
60     /// @dev Get a 5 bit slice from an input as a number
61     /// @param _input bits, encoded as uint
62     /// @param _slot from 0 to 50
63     function _get5Bits(uint256 _input, uint256 _slot) internal pure returns(uint8) {
64         return uint8(_sliceNumber(_input, uint256(5), _slot * 5));
65     }
66 
67     /// @dev Parse a kitten gene and returns all of 12 "trait stack" that makes the characteristics
68     /// @param _genes kitten gene
69     /// @return the 48 traits that composes the genetic code, logically divided in stacks of 4, where only the first trait of each stack may express
70     function decode(uint256 _genes) public pure returns(uint8[]) {
71         uint8[] memory traits = new uint8[](48);
72         uint256 i;
73         for(i = 0; i < 48; i++) {
74             traits[i] = _get5Bits(_genes, i);
75         }
76         return traits;
77     }
78 
79     /// @dev Given an array of traits return the number that represent genes
80     function encode(uint8[] _traits) public pure returns (uint256 _genes) {
81         _genes = 0;
82         for(uint256 i = 0; i < 48; i++) {
83             _genes = _genes << 5;
84             // bitwise OR trait with _genes
85             _genes = _genes | _traits[47 - i];
86         }
87         return _genes;
88     }
89 
90     /// @dev return the expressing traits
91     /// @param _genes the long number expressing cat genes
92     function expressingTraits(uint256 _genes) public pure returns(uint8[12]) {
93         uint8[12] memory express;
94         for(uint256 i = 0; i < 12; i++) {
95             express[i] = _get5Bits(_genes, i * 4);
96         }
97         return express;
98     }
99 
100     /// @dev the function as defined in the breeding contract - as defined in CK bible
101     function mixGenes(uint256 _genes1, uint256 _genes2, uint256 _targetBlock) public returns (uint256) {
102         require(block.number > _targetBlock);
103 
104         // Try to grab the hash of the "target block". This should be available the vast
105         // majority of the time (it will only fail if no-one calls giveBirth() within 256
106         // blocks of the target block, which is about 40 minutes. Since anyone can call
107         // giveBirth() and they are rewarded with ether if it succeeds, this is quite unlikely.)
108         uint256 randomN = uint256(block.blockhash(_targetBlock));
109 
110         if (randomN == 0) {
111             // We don't want to completely bail if the target block is no-longer available,
112             // nor do we want to just use the current block's hash (since it could allow a
113             // caller to game the random result). Compute the most recent block that has the
114             // the same value modulo 256 as the target block. The hash for this block will
115             // still be available, and – while it can still change as time passes – it will
116             // only change every 40 minutes. Again, someone is very likely to jump in with
117             // the giveBirth() call before it can cycle too many times.
118             _targetBlock = (block.number & maskFirst248Bits) + (_targetBlock & maskLast8Bits);
119 
120             // The computation above could result in a block LARGER than the current block,
121             // if so, subtract 256.
122             if (_targetBlock >= block.number) _targetBlock -= 256;
123 
124             randomN = uint256(block.blockhash(_targetBlock));
125 
126             // DEBUG ONLY
127             // assert(block.number != _targetBlock);
128             // assert((block.number - _targetBlock) <= 256);
129             // assert(randomN != 0);
130         }
131 
132         // generate 256 bits of random, using as much entropy as we can from
133         // sources that can't change between calls.
134         randomN = uint256(keccak256(randomN, _genes1, _genes2, _targetBlock));
135         uint256 randomIndex = 0;
136 
137         uint8[] memory genes1Array = decode(_genes1);
138         uint8[] memory genes2Array = decode(_genes2);
139         // All traits that will belong to baby
140         uint8[] memory babyArray = new uint8[](48);
141         // A pointer to the trait we are dealing with currently
142         uint256 traitPos;
143         // Trait swap value holder
144         uint8 swap;
145         // iterate all 12 characteristics
146         for(uint256 i = 0; i < 12; i++) {
147             // pick 4 traits for characteristic i
148             uint256 j;
149             // store the current random value
150             uint256 rand;
151             for(j = 3; j >= 1; j--) {
152                 traitPos = (i * 4) + j;
153 
154                 rand = _sliceNumber(randomN, 2, randomIndex); // 0~3
155                 randomIndex += 2;
156 
157                 // 1/4 of a chance of gene swapping forward towards expressing.
158                 if (rand == 0) {
159                     // do it for parent 1
160                     swap = genes1Array[traitPos];
161                     genes1Array[traitPos] = genes1Array[traitPos - 1];
162                     genes1Array[traitPos - 1] = swap;
163 
164                 }
165 
166                 rand = _sliceNumber(randomN, 2, randomIndex); // 0~3
167                 randomIndex += 2;
168 
169                 if (rand == 0) {
170                     // do it for parent 2
171                     swap = genes2Array[traitPos];
172                     genes2Array[traitPos] = genes2Array[traitPos - 1];
173                     genes2Array[traitPos - 1] = swap;
174                 }
175             }
176 
177         }
178 
179         // DEBUG ONLY - We should have used 72 2-bit slices above for the swapping
180         // which will have consumed 144 bits.
181         // assert(randomIndex == 144);
182 
183         // We have 256 - 144 = 112 bits of randomness left at this point. We will use up to
184         // four bits for the first slot of each trait (three for the possible ascension, one
185         // to pick between mom and dad if the ascension fails, for a total of 48 bits. The other
186         // traits use one bit to pick between parents (36 gene pairs, 36 genes), leaving us
187         // well within our entropy budget.
188 
189         // done shuffling parent genes, now let's decide on choosing trait and if ascending.
190         // NOTE: Ascensions ONLY happen in the "top slot" of each characteristic. This saves
191         //  gas and also ensures ascensions only happen when they're visible.
192         for(traitPos = 0; traitPos < 48; traitPos++) {
193 
194             // See if this trait pair should ascend
195             uint8 ascendedTrait = 0;
196 
197             // There are two checks here. The first is straightforward, only the trait
198             // in the first slot can ascend. The first slot is zero mod 4.
199             //
200             // The second check is more subtle: Only values that are one apart can ascend,
201             // which is what we check inside the _ascend method. However, this simple mask
202             // and compare is very cheap (9 gas) and will filter out about half of the
203             // non-ascending pairs without a function call.
204             //
205             // The comparison itself just checks that one value is even, and the other
206             // is odd.
207             if ((traitPos % 4 == 0) && (genes1Array[traitPos] & 1) != (genes2Array[traitPos] & 1)) {
208                 rand = _sliceNumber(randomN, 3, randomIndex);
209                 randomIndex += 3;
210 
211                 ascendedTrait = _ascend(genes1Array[traitPos], genes2Array[traitPos], rand);
212             }
213 
214             if (ascendedTrait > 0) {
215                 babyArray[traitPos] = uint8(ascendedTrait);
216             } else {
217                 // did not ascend, pick one of the parent's traits for the baby
218                 // We use the top bit of rand for this (the bottom three bits were used
219                 // to check for the ascension itself).
220                 rand = _sliceNumber(randomN, 1, randomIndex);
221                 randomIndex += 1;
222 
223                 if (rand == 0) {
224                     babyArray[traitPos] = uint8(genes1Array[traitPos]);
225                 } else {
226                     babyArray[traitPos] = uint8(genes2Array[traitPos]);
227                 }
228             }
229         }
230 
231         return encode(babyArray);
232     }
233 }