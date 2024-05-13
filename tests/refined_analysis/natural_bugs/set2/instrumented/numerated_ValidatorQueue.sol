1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {SafeCast} from "openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
5 import {DataTypes} from "./DataTypes.sol";
6 import {Errors} from "./Errors.sol";
7 
8 /**
9  * @title ValidatorQueue
10  * @notice Library for managing a FIFO queue of validators in the Pirex protocol.
11  * @dev This library provides functions for adding, swapping, and removing validators in the validator queue.
12  * It also includes functions for popping validators from the end of the queue, retrieving validator information, and clearing the entire queue.
13  * @author redactedcartel.finance
14  */
15 library ValidatorQueue {
16     /**
17      * @notice Emitted when a validator is added to the queue.
18      * @dev This event is emitted when a validator is successfully added to the end of the queue.
19      * @param pubKey               bytes Public key of the added validator.
20      * @param withdrawalCredential bytes Withdrawal credentials associated with the added validator.
21      */
22     event ValidatorAdded(bytes pubKey, bytes withdrawalCredential);
23 
24     /**
25      * @notice Emitted when the entire validator queue is cleared.
26      * @dev This event is emitted when all validators are removed from the queue, clearing it completely.
27      */
28     event ValidatorQueueCleared();
29 
30     /**
31      * @notice Emitted when a validator is removed from the queue.
32      * @dev This event is emitted when a validator is successfully removed from the queue, either ordered or unordered.
33      * @param pubKey      bytes   Public key of the removed validator.
34      * @param removeIndex uint256 Index of the removed validator.
35      * @param unordered   bool    Indicates whether the removal was unordered.
36      */
37     event ValidatorRemoved(bytes pubKey, uint256 removeIndex, bool unordered);
38 
39     /**
40      * @notice Emitted when validators are popped from the front of the queue.
41      * @dev This event is emitted when validators are successfully popped from the front of the queue.
42      * @param times uint256 Number of pop operations performed.
43      */
44     event ValidatorsPopped(uint256 times);
45 
46     /**
47      * @notice Emitted when two validators are swapped in the queue.
48      * @dev This event is emitted when two validators are successfully swapped in the queue.
49      * @param fromPubKey bytes   Public key of the first validator being swapped.
50      * @param toPubKey   bytes   Public key of the second validator being swapped.
51      * @param fromIndex  uint256 Index of the first validator.
52      * @param toIndex    uint256 Index of the second validator.
53      */
54     event ValidatorsSwapped(
55         bytes fromPubKey,
56         bytes toPubKey,
57         uint256 fromIndex,
58         uint256 toIndex
59     );
60 
61     /**
62      * @notice Adds a synchronized validator to the FIFO queue, ready for staking.
63      * @dev This function adds a validator to the end of the queue with the associated withdrawal credentials.
64      * @param deque                 DataTypes.ValidatorDeque Storage reference to the validator deque.
65      * @param validator             DataTypes.Validator      Validator information to be added.
66      * @param withdrawalCredentials bytes                    Withdrawal credentials associated with the validator.
67      */
68     function add(
69         DataTypes.ValidatorDeque storage deque,
70         DataTypes.Validator memory validator,
71         bytes memory withdrawalCredentials
72     ) external {
73         int128 backIndex = deque._end;
74         deque._validators[backIndex] = validator;
75 
76         unchecked {
77             deque._end = backIndex + 1;
78         }
79 
80         emit ValidatorAdded(validator.pubKey, withdrawalCredentials);
81     }
82 
83     /**
84      * @notice Swaps the location of one validator with another.
85      * @dev This function swaps the position of two validators in the queue.
86      * @param deque     DataTypes.ValidatorDeque Storage reference to the validator deque.
87      * @param fromIndex uint256                  Index of the validator to be swapped.
88      * @param toIndex   uint256                  Index of the validator to swap with.
89      */
90     function swap(
91         DataTypes.ValidatorDeque storage deque,
92         uint256 fromIndex,
93         uint256 toIndex
94     ) public {
95         if (fromIndex == toIndex) revert Errors.InvalidIndexRanges();
96         if (empty(deque)) revert Errors.ValidatorQueueEmpty();
97 
98         int128 fromidx = SafeCast.toInt128(
99             int256(deque._begin) + SafeCast.toInt256(fromIndex)
100         );
101 
102         if (fromidx >= deque._end) revert Errors.OutOfBounds();
103 
104         int128 toidx = SafeCast.toInt128(
105             int256(deque._begin) + SafeCast.toInt256(toIndex)
106         );
107 
108         if (toidx >= deque._end) revert Errors.OutOfBounds();
109 
110         // Get the original values
111         DataTypes.Validator memory fromVal = deque._validators[fromidx];
112         DataTypes.Validator memory toVal = deque._validators[toidx];
113 
114         // Set the swapped values
115         deque._validators[toidx] = fromVal;
116         deque._validators[fromidx] = toVal;
117 
118         emit ValidatorsSwapped(
119             fromVal.pubKey,
120             toVal.pubKey,
121             fromIndex,
122             toIndex
123         );
124     }
125 
126     /**
127      * @notice Removes validators from the end of the queue, in case they were added in error.
128      * @dev This function removes validators from the end of the queue, specified by the number of times to pop.
129      * @param  deque     DataTypes.ValidatorDeque Storage reference to the validator deque.
130      * @param  times     uint256                  Number of pop operations to perform.
131      * @return validator DataTypes.Validator      Removed and returned validator.
132      */
133     function pop(
134         DataTypes.ValidatorDeque storage deque,
135         uint256 times
136     ) public returns (DataTypes.Validator memory validator) {
137         // Loop through and remove validator entries at the end
138         for (uint256 _i; _i < times; ) {
139             if (empty(deque)) revert Errors.ValidatorQueueEmpty();
140 
141             int128 backIndex;
142 
143             unchecked {
144                 backIndex = deque._end - 1;
145                 ++_i;
146             }
147 
148             validator = deque._validators[backIndex];
149             delete deque._validators[backIndex];
150             deque._end = backIndex;
151         }
152 
153         emit ValidatorsPopped(times);
154     }
155 
156     /**
157      * @notice Check if the deque is empty
158      * @dev Returns true if the validator deque is empty, otherwise false.
159      * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
160      * @return      bool                     True if the deque is empty, otherwise false.
161      */
162     function empty(
163         DataTypes.ValidatorDeque storage deque
164     ) public view returns (bool) {
165         return deque._end <= deque._begin;
166     }
167 
168     /**
169      * @notice Remove a validator from the array using a more gas-efficient loop.
170      * @dev Removes a validator at the specified index and emits an event.
171      * @param  deque         DataTypes.ValidatorDeque Storage reference to the validator deque.
172      * @param  removeIndex   uint256                  Index of the validator to remove.
173      * @return removedPubKey bytes                    Public key of the removed validator.
174      */
175     function removeOrdered(
176         DataTypes.ValidatorDeque storage deque,
177         uint256 removeIndex
178     ) external returns (bytes memory removedPubKey) {
179         int128 idx = SafeCast.toInt128(
180             int256(deque._begin) + SafeCast.toInt256(removeIndex)
181         );
182 
183         if (idx >= deque._end) revert Errors.OutOfBounds();
184 
185         // Get the pubkey for the validator to remove (for informational purposes)
186         removedPubKey = deque._validators[idx].pubKey;
187 
188         for (int128 _i = idx; _i < deque._end - 1; ) {
189             deque._validators[_i] = deque._validators[_i + 1];
190 
191             unchecked {
192                 ++_i;
193             }
194         }
195 
196         pop(deque, 1);
197 
198         emit ValidatorRemoved(removedPubKey, removeIndex, false);
199     }
200 
201     /**
202      * @notice Remove a validator from the array using swap and pop.
203      * @dev Removes a validator at the specified index by swapping it with the last validator and then popping the last validator.
204      * @param  deque         DataTypes.ValidatorDeque Storage reference to the validator deque.
205      * @param  removeIndex   uint256                  Index of the validator to remove.
206      * @return removedPubkey bytes                    Public key of the removed validator.
207      */
208     function removeUnordered(
209         DataTypes.ValidatorDeque storage deque,
210         uint256 removeIndex
211     ) external returns (bytes memory removedPubkey) {
212         int128 idx = SafeCast.toInt128(
213             int256(deque._begin) + SafeCast.toInt256(removeIndex)
214         );
215 
216         if (idx >= deque._end) revert Errors.OutOfBounds();
217 
218         // Get the pubkey for the validator to remove (for informational purposes)
219         removedPubkey = deque._validators[idx].pubKey;
220 
221         // Swap the (validator to remove) with the last validator in the array if needed
222         uint256 lastIndex = count(deque) - 1;
223         if (removeIndex != lastIndex) {
224             swap(deque, removeIndex, lastIndex);
225         }
226 
227         // Pop off the validator to remove, which is now at the end of the array
228         pop(deque, 1);
229 
230         emit ValidatorRemoved(removedPubkey, removeIndex, true);
231     }
232 
233     /**
234      * @notice Remove the last validator from the validators array and return its information
235      * @dev Removes and returns information about the last validator in the queue.
236      * @param  deque                   DataTypes.ValidatorDeque  Deque
237      * @param  _withdrawalCredentials  bytes                     Credentials
238      * @return pubKey                  bytes                     Key
239      * @return withdrawalCredentials   bytes                     Credentials
240      * @return signature               bytes                     Signature
241      * @return depositDataRoot         bytes32                   Deposit data root
242      * @return receiver                address                   account to receive pxEth
243      */
244     function getNext(
245         DataTypes.ValidatorDeque storage deque,
246         bytes memory _withdrawalCredentials
247     )
248         external
249         returns (
250             bytes memory pubKey,
251             bytes memory withdrawalCredentials,
252             bytes memory signature,
253             bytes32 depositDataRoot,
254             address receiver
255         )
256     {
257         if (empty(deque)) revert Errors.ValidatorQueueEmpty();
258 
259         int128 frontIndex = deque._begin;
260         DataTypes.Validator memory popped = deque._validators[frontIndex];
261         delete deque._validators[frontIndex];
262 
263         unchecked {
264             deque._begin = frontIndex + 1;
265         }
266 
267         // Return the validator's information
268         pubKey = popped.pubKey;
269         withdrawalCredentials = _withdrawalCredentials;
270         signature = popped.signature;
271         depositDataRoot = popped.depositDataRoot;
272         receiver = popped.receiver;
273     }
274 
275     /**
276      * @notice Return the information of the i'th validator in the registry
277      * @dev Returns information about the validator at the specified index without removing it from the deque.
278      * @param  deque                   DataTypes.ValidatorDeque  Deque
279      * @param  _withdrawalCredentials  bytes                     Credentials
280      * @param  _index                  uint256                   Index
281      * @return pubKey                  bytes                     Key
282      * @return withdrawalCredentials   bytes                     Credentials
283      * @return signature               bytes                     Signature
284      * @return depositDataRoot         bytes32                   Deposit data root
285      * @return receiver                address                   account to receive pxEth
286      */
287     function get(
288         DataTypes.ValidatorDeque storage deque,
289         bytes memory _withdrawalCredentials,
290         uint256 _index
291     )
292         external
293         view
294         returns (
295             bytes memory pubKey,
296             bytes memory withdrawalCredentials,
297             bytes memory signature,
298             bytes32 depositDataRoot,
299             address receiver
300         )
301     {
302         // int256(deque._begin) is a safe upcast
303         int128 idx = SafeCast.toInt128(
304             int256(deque._begin) + SafeCast.toInt256(_index)
305         );
306 
307         if (idx >= deque._end) revert Errors.OutOfBounds();
308 
309         DataTypes.Validator memory _v = deque._validators[idx];
310 
311         // Return the validator's information
312         pubKey = _v.pubKey;
313         withdrawalCredentials = _withdrawalCredentials;
314         signature = _v.signature;
315         depositDataRoot = _v.depositDataRoot;
316         receiver = _v.receiver;
317     }
318 
319     /**
320      * @notice Empties the validator queue.
321      * @dev Clears the entire validator deque, setting both begin and end to 0.
322      *      Emits an event to signal the clearing of the queue.
323      * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
324      */
325     function clear(DataTypes.ValidatorDeque storage deque) external {
326         deque._begin = 0;
327         deque._end = 0;
328 
329         emit ValidatorQueueCleared();
330     }
331 
332     /**
333      * @notice Returns the number of validators in the queue.
334      * @dev Calculates and returns the number of validators in the deque.
335      * @param deque DataTypes.ValidatorDeque Storage reference to the validator deque.
336      * @return      uint256                  Number of validators in the deque.
337      */
338     function count(
339         DataTypes.ValidatorDeque storage deque
340     ) public view returns (uint256) {
341         // The interface preserves the invariant that begin <= end so we assume this will not overflow.
342         // We also assume there are at most int256.max items in the queue.
343         unchecked {
344             return uint256(int256(deque._end) - int256(deque._begin));
345         }
346     }
347 }
