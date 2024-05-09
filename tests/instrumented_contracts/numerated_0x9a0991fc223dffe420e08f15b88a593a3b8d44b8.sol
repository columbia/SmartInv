1 pragma solidity ^0.4.19;
2 // Danku contract version 0.0.1
3 // Data points are x, y, and z
4 
5 contract Danku_demo {
6   function Danku_demo() public {
7     // Neural Network Structure:
8     //
9     // (assertd) input layer x number of neurons
10     // (optional) hidden layers x number of neurons
11     // (assertd) output layer x number of neurons
12   }
13   struct Submission {
14       address payment_address;
15       // Define the number of neurons each layer has.
16       uint num_neurons_input_layer;
17       uint num_neurons_output_layer;
18       // There can be multiple hidden layers.
19       uint[] num_neurons_hidden_layer;
20       // Weights indexes are the following:
21       // weights[l_i x l_n_i x pl_n_i]
22       // Also number of layers in weights is layers.length-1
23       int256[] weights;
24       int256[] biases;
25   }
26   struct NeuralLayer {
27     int256[] neurons;
28     int256[] errors;
29     string layer_type;
30   }
31 
32   address public organizer;
33   // Keep track of the best model
34   uint public best_submission_index;
35   // Keep track of best model accuracy
36   int256 public best_submission_accuracy = 0;
37   // The model accuracy criteria
38   int256 public model_accuracy_criteria;
39   // Use test data if provided
40   bool public use_test_data = false;
41   // Each partition is 5% of the total dataset size
42   uint constant partition_size = 25;
43   // Data points are made up of x and y coordinates and the prediction
44   uint constant datapoint_size = 3;
45   uint constant prediction_size = 1;
46   // Max number of data groups
47   // Change this to your data group size
48   uint16 constant max_num_data_groups = 500;
49   // Training partition size
50   uint16 constant training_data_group_size = 400;
51   // Testing partition size
52   uint16 constant testing_data_group_size = max_num_data_groups - training_data_group_size;
53   // Dataset is divided into data groups.
54   // Every data group includes a nonce.
55   // Look at sha_data_group() for more detail about hashing a data group
56   bytes32[max_num_data_groups/partition_size] hashed_data_groups;
57   // Nonces are revelead together with data groups
58   uint[max_num_data_groups/partition_size] data_group_nonces;
59   // + 1 for prediction
60   // A data group has 3 data points in total
61   int256[datapoint_size][] public train_data;
62   int256[datapoint_size][] public test_data;
63   bytes32 partition_seed;
64   // Deadline for submitting solutions in terms of block size
65   uint public submission_stage_block_size = 241920; // 6 weeks timeframe
66   // Deadline for revealing the testing dataset
67   uint public reveal_test_data_groups_block_size = 17280; // 3 days timeframe
68   // Deadline for evaluating the submissions
69   uint public evaluation_stage_block_size = 40320; // 7 days timeframe
70   uint public init1_block_height;
71   uint public init3_block_height;
72   uint public init_level = 0;
73   // Training partition size is 14 (70%)
74   // Testing partition size is 6 (30%)
75   uint[training_data_group_size/partition_size] public training_partition;
76   uint[testing_data_group_size/partition_size] public testing_partition;
77   uint256 train_dg_revealed = 0;
78   uint256 test_dg_revealed = 0;
79   Submission[] submission_queue;
80   bool public contract_terminated = false;
81   // Integer precision for calculating float values for weights and biases
82   int constant int_precision = 10000;
83 
84   // Takes in array of hashed data points of the entire dataset,
85   // submission and evaluation times
86   function init1(bytes32[max_num_data_groups/partition_size] _hashed_data_groups, int accuracy_criteria, address organizer_refund_address) external {
87     // Make sure contract is not terminated
88     assert(contract_terminated == false);
89     // Make sure it's called in order
90     assert(init_level == 0);
91     organizer = organizer_refund_address;
92     init_level = 1;
93     init1_block_height = block.number;
94 
95     // Make sure there are in total 20 hashed data groups
96     assert(_hashed_data_groups.length == max_num_data_groups/partition_size);
97     hashed_data_groups = _hashed_data_groups;
98     // Accuracy criteria example: 85.9% => 8,590
99     // 100 % => 10,000
100     assert(accuracy_criteria > 0);
101     model_accuracy_criteria = accuracy_criteria;
102   }
103 
104   function init2() external {
105     // Make sure contract is not terminated
106     assert(contract_terminated == false);
107     // Only allow calling it once, in order
108     assert(init_level == 1);
109     // Make sure it's being called within 20 blocks on init1()
110     // to minimize organizer influence on random index selection
111     if (block.number <= init1_block_height+20 && block.number > init1_block_height) {
112       // TODO: Also make sure it's being called 1 block after init1()
113       // Randomly select indexes
114       uint[] memory index_array = new uint[](max_num_data_groups/partition_size);
115       for (uint i = 0; i < max_num_data_groups/partition_size; i++) {
116         index_array[i] = i;
117       }
118       randomly_select_index(index_array);
119       init_level = 2;
120     } else {
121       // Cancel the contract if init2() hasn't been called within 5
122       // blocks of init1()
123       cancel_contract();
124     }
125   }
126 
127   function init3(int256[] _train_data_groups, int256 _train_data_group_nonces) external {
128     // Pass a single data group at a time
129     // Make sure contract is not terminated
130     assert(contract_terminated == false);
131     // Only allow calling once, in order
132     assert(init_level == 2);
133     // Verify data group and nonce lengths
134     assert((_train_data_groups.length/partition_size)/datapoint_size == 1);
135     // Verify data group hashes
136     // Order of revealed training data group must be the same with training partitions
137     // Otherwise hash verification will fail
138     assert(sha_data_group(_train_data_groups, _train_data_group_nonces) ==
139       hashed_data_groups[training_partition[train_dg_revealed]]);
140     train_dg_revealed += 1;
141     // Assign training data after verifying the corresponding hash
142     unpack_data_groups(_train_data_groups, true);
143     if (train_dg_revealed == (training_data_group_size/partition_size)) {
144       init_level = 3;
145       init3_block_height = block.number;
146     }
147   }
148 
149   function get_training_index() public view returns(uint[training_data_group_size/partition_size]) {
150     return training_partition;
151   }
152 
153   function get_testing_index() public view returns(uint[testing_data_group_size/partition_size]) {
154     return testing_partition;
155   }
156 
157   function get_submission_queue_length() public view returns(uint) {
158     return submission_queue.length;
159   }
160 
161   function submit_model(
162     // Public function for users to submit a solution
163     address payment_address,
164     uint num_neurons_input_layer,
165     uint num_neurons_output_layer,
166     uint[] num_neurons_hidden_layer,
167     int[] weights,
168     int256[] biases) public {
169       // Make sure contract is not terminated
170       assert(contract_terminated == false);
171       // Make sure it's not the initialization stage anymore
172       assert(init_level == 3);
173       // Make sure it's still within the submission stage
174       assert(block.number < init3_block_height + submission_stage_block_size);
175       // Make sure that num of neurons in the input & output layer matches
176       // the problem description
177       assert(num_neurons_input_layer == datapoint_size - prediction_size);
178       // Because we can encode binary output in two different ways, we check
179       // for both of them
180       assert(num_neurons_output_layer == prediction_size || num_neurons_output_layer == (prediction_size+1));
181       // Make sure that the number of weights match network structure
182       assert(valid_weights(weights, num_neurons_input_layer, num_neurons_output_layer, num_neurons_hidden_layer));
183       // Add solution to submission queue
184       submission_queue.push(Submission(
185         payment_address,
186         num_neurons_input_layer,
187         num_neurons_output_layer,
188         num_neurons_hidden_layer,
189         weights,
190         biases));
191   }
192 
193   function get_submission_id(
194     // Public function that returns the submission index ID
195     address paymentAddress,
196     uint num_neurons_input_layer,
197     uint num_neurons_output_layer,
198     uint[] num_neurons_hidden_layer,
199     int[] weights,
200     int256[] biases) public view returns (uint) {
201       // Iterate over submission queue to get submission index ID
202       for (uint i = 0; i < submission_queue.length; i++) {
203         if (submission_queue[i].payment_address != paymentAddress) {
204           continue;
205         }
206         if (submission_queue[i].num_neurons_input_layer != num_neurons_input_layer) {
207           continue;
208         }
209         if (submission_queue[i].num_neurons_output_layer != num_neurons_output_layer) {
210           continue;
211         }
212         for (uint j = 0; j < num_neurons_hidden_layer.length; j++) {
213             if (submission_queue[i].num_neurons_hidden_layer[j] != num_neurons_hidden_layer[j]) {
214               continue;
215             }
216         }
217         for (uint k = 0; k < weights.length; k++) {
218             if (submission_queue[i].weights[k] != weights[k]) {
219               continue;
220             }
221         }
222         for (uint l = 0; l < biases.length; l++) {
223           if (submission_queue[i].biases[l] != biases[l]) {
224             continue;
225           }
226         }
227         // If everything matches, return the submission index
228         return i;
229       }
230       // If submission is not in the queue, just throw an exception
231       require(false);
232   }
233 
234     function reveal_test_data(int256[] _test_data_groups, int256 _test_data_group_nonces) external {
235     // Make sure contract is not terminated
236     assert(contract_terminated == false);
237     // Make sure it's not the initialization stage anymore
238     assert(init_level == 3);
239     // Make sure it's revealed after the submission stage
240     assert(block.number >= init3_block_height + submission_stage_block_size);
241     // Make sure it's revealed within the reveal stage
242     assert(block.number < init3_block_height + submission_stage_block_size + reveal_test_data_groups_block_size);
243     // Verify data group and nonce lengths
244     assert((_test_data_groups.length/partition_size)/datapoint_size == 1);
245     // Verify data group hashes
246     assert(sha_data_group(_test_data_groups, _test_data_group_nonces) ==
247       hashed_data_groups[testing_partition[test_dg_revealed]]);
248     test_dg_revealed += 1;
249     // Assign testing data after verifying the corresponding hash
250     unpack_data_groups(_test_data_groups, false);
251     // Use test data for evaluation
252     use_test_data = true;
253   }
254 
255   function evaluate_model(uint submission_index) public {
256     // TODO: Make sure that if there's two same submission w/ same weights
257     // and biases, the first one submitted should get the reward.
258     // Make sure contract is not terminated
259     assert(contract_terminated == false);
260     // Make sure it's not the initialization stage anymore
261     assert(init_level == 3);
262     // Make sure it's evaluated after the reveal stage
263     assert(block.number >= init3_block_height + submission_stage_block_size + reveal_test_data_groups_block_size);
264     // Make sure it's evaluated within the evaluation stage
265     assert(block.number < init3_block_height + submission_stage_block_size + reveal_test_data_groups_block_size + evaluation_stage_block_size);
266     // Evaluates a submitted model & keeps track of the best model
267     int256 submission_accuracy = 0;
268     if (use_test_data == true) {
269       submission_accuracy = model_accuracy(submission_index, test_data);
270     } else {
271       submission_accuracy = model_accuracy(submission_index, train_data);
272     }
273 
274     // Keep track of the most accurate model
275     if (submission_accuracy > best_submission_accuracy) {
276       best_submission_index = submission_index;
277       best_submission_accuracy = submission_accuracy;
278     }
279   }
280 
281   function cancel_contract() public {
282     // Make sure contract is not already terminated
283     assert(contract_terminated == false);
284     // Contract can only be cancelled if initialization has failed.
285     assert(init_level < 3);
286     // Refund remaining balance to organizer
287     organizer.transfer(this.balance);
288     // Terminate contract
289     contract_terminated = true;
290   }
291 
292   function finalize_contract() public {
293     // Make sure contract is not terminated
294     assert(contract_terminated == false);
295     // Make sure it's not the initialization stage anymore
296     assert(init_level == 3);
297     // Make sure the contract is finalized after the evaluation stage
298     assert(block.number >= init3_block_height + submission_stage_block_size + reveal_test_data_groups_block_size + evaluation_stage_block_size);
299     // Get the best submission to compare it against the criteria
300     Submission memory best_submission = submission_queue[best_submission_index];
301     // If best submission passes criteria, payout to the submitter
302     if (best_submission_accuracy >= model_accuracy_criteria) {
303       best_submission.payment_address.transfer(this.balance);
304     // If the best submission fails the criteria, refund the balance back to the organizer
305     } else {
306       organizer.transfer(this.balance);
307     }
308     contract_terminated = true;
309   }
310 
311   function model_accuracy(uint submission_index, int256[datapoint_size][] data) public constant returns (int256){
312     // Make sure contract is not terminated
313     assert(contract_terminated == false);
314     // Make sure it's not the initialization stage anymore
315     assert(init_level == 3);
316     // Leave function public for offline error calculation
317     // Get's the sum error for the model
318     Submission memory sub = submission_queue[submission_index];
319     int256 true_prediction = 0;
320     int256 false_prediction = 0;
321     bool one_hot; // one-hot encoding if prediction size is 1 but model output size is 2
322     int[] memory prediction;
323     int[] memory ground_truth;
324     if ((prediction_size + 1) == sub.num_neurons_output_layer) {
325       one_hot = true;
326       prediction = new int[](sub.num_neurons_output_layer);
327       ground_truth = new int[](sub.num_neurons_output_layer);
328     } else {
329       one_hot = false;
330       prediction = new int[](prediction_size);
331       ground_truth = new int[](prediction_size);
332     }
333     for (uint i = 0; i < data.length; i++) {
334       // Get ground truth
335       for (uint j = datapoint_size-prediction_size; j < data[i].length; j++) {
336         uint d_index = j - datapoint_size + prediction_size;
337         // Only get prediction values
338         if (one_hot == true) {
339           if (data[i][j] == 0) {
340             ground_truth[d_index] = 1;
341             ground_truth[d_index + 1] = 0;
342           } else if (data[i][j] == 1) {
343             ground_truth[d_index] = 0;
344             ground_truth[d_index + 1] = 1;
345           } else {
346             // One-hot encoding for more than 2 classes is not supported
347             require(false);
348           }
349         } else {
350           ground_truth[d_index] = data[i][j];
351         }
352       }
353       // Get prediction
354       prediction = get_prediction(sub, data[i]);
355       // Get error for the output layer
356       for (uint k = 0; k < ground_truth.length; k++) {
357         if (ground_truth[k] == prediction[k]) {
358           true_prediction += 1;
359         } else {
360           false_prediction += 1;
361         }
362       }
363     }
364     // We multipl by int_precision to get up to x decimal point precision while
365     // calculating the accuracy
366     return (true_prediction * int_precision) / (true_prediction + false_prediction);
367   }
368 
369   function get_train_data_length() public view returns(uint256) {
370     return train_data.length;
371   }
372 
373   function get_test_data_length() public view returns(uint256) {
374     return test_data.length;
375   }
376 
377   function round_up_division(int256 dividend, int256 divisor) private pure returns(int256) {
378     // A special trick since solidity normall rounds it down
379     return (dividend + divisor -1) / divisor;
380   }
381 
382   function not_in_train_partition(uint[training_data_group_size/partition_size] partition, uint number) private pure returns (bool) {
383     for (uint i = 0; i < partition.length; i++) {
384       if (number == partition[i]) {
385         return false;
386       }
387     }
388     return true;
389   }
390 
391   function randomly_select_index(uint[] array) private {
392     uint t_index = 0;
393     uint array_length = array.length;
394     uint block_i = 0;
395     // Randomly select training indexes
396     while(t_index < training_partition.length) {
397       uint random_index = uint(sha256(block.blockhash(block.number-block_i))) % array_length;
398       training_partition[t_index] = array[random_index];
399       array[random_index] = array[array_length-1];
400       array_length--;
401       block_i++;
402       t_index++;
403     }
404     t_index = 0;
405     while(t_index < testing_partition.length) {
406       testing_partition[t_index] = array[array_length-1];
407       array_length--;
408       t_index++;
409     }
410   }
411 
412   function valid_weights(int[] weights, uint num_neurons_input_layer, uint num_neurons_output_layer, uint[] num_neurons_hidden_layer) private pure returns (bool) {
413     // make sure the number of weights match the network structure
414     // get number of weights based on network structure
415     uint ns_total = 0;
416     uint wa_total = 0;
417     uint number_of_layers = 2 + num_neurons_hidden_layer.length;
418 
419     if (number_of_layers == 2) {
420       ns_total = num_neurons_input_layer * num_neurons_output_layer;
421     } else {
422       for(uint i = 0; i < num_neurons_hidden_layer.length; i++) {
423         // Get weights between first hidden layer and input layer
424         if (i==0){
425           ns_total += num_neurons_input_layer * num_neurons_hidden_layer[i];
426         // Get weights between hidden layers
427         } else {
428           ns_total += num_neurons_hidden_layer[i-1] * num_neurons_hidden_layer[i];
429         }
430       }
431       // Get weights between last hidden layer and output layer
432       ns_total += num_neurons_hidden_layer[num_neurons_hidden_layer.length-1] * num_neurons_output_layer;
433     }
434     // get number of weights in the weights array
435     wa_total = weights.length;
436 
437     return ns_total == wa_total;
438   }
439 
440     function unpack_data_groups(int256[] _data_groups, bool is_train_data) private {
441     int256[datapoint_size][] memory merged_data_group = new int256[datapoint_size][](_data_groups.length/datapoint_size);
442 
443     for (uint i = 0; i < _data_groups.length/datapoint_size; i++) {
444       for (uint j = 0; j < datapoint_size; j++) {
445         merged_data_group[i][j] = _data_groups[i*datapoint_size + j];
446       }
447     }
448     if (is_train_data == true) {
449       // Assign training data
450       for (uint k = 0; k < merged_data_group.length; k++) {
451         train_data.push(merged_data_group[k]);
452       }
453     } else {
454       // Assign testing data
455       for (uint l = 0; l < merged_data_group.length; l++) {
456         test_data.push(merged_data_group[l]);
457       }
458     }
459   }
460 
461     function sha_data_group(int256[] data_group, int256 data_group_nonce) private pure returns (bytes32) {
462       // Extract the relevant data points for the given data group index
463       // We concat all data groups and add the nounce to the end of the array
464       // and get the sha256 for the array
465       uint index_tracker = 0;
466       uint256 total_size = datapoint_size * partition_size;
467       /* uint256 start_index = data_group_index * total_size;
468       uint256 iter_limit = start_index + total_size; */
469       int256[] memory all_data_points = new int256[](total_size+1);
470 
471       for (uint256 i = 0; i < total_size; i++) {
472         all_data_points[index_tracker] = data_group[i];
473         index_tracker += 1;
474       }
475       // Add nonce to the whole array
476       all_data_points[index_tracker] = data_group_nonce;
477       // Return sha256 on all data points + nonce
478       return sha256(all_data_points);
479     }
480 
481   function relu_activation(int256 x) private pure returns (int256) {
482     if (x < 0) {
483       return 0;
484     } else {
485       return x;
486     }
487   }
488 
489   function get_layer(uint nn) private pure returns (int256[]) {
490     int256[] memory input_layer = new int256[](nn);
491     return input_layer;
492   }
493 
494   function get_hidden_layers(uint[] l_nn) private pure returns (int256[]) {
495     uint total_nn = 0;
496     // Skip first and last layer since they're not hidden layers
497     for (uint i = 1; i < l_nn.length-1; i++) {
498       total_nn += l_nn[i];
499     }
500     int256[] memory hidden_layers = new int256[](total_nn);
501     return hidden_layers;
502   }
503 
504   function access_hidden_layer(int256[] hls, uint[] l_nn, uint index) private pure returns (int256[]) {
505     // TODO: Bug is here, doesn't work for between last hidden and output layer
506     // Returns the hidden layer from the hidden layers array
507     int256[] memory hidden_layer = new int256[](l_nn[index+1]);
508     uint hidden_layer_index = 0;
509     uint start = 0;
510     uint end = 0;
511     for (uint i = 0; i < index; i++) {
512       start += l_nn[i+1];
513     }
514     for (uint j = 0; j < (index + 1); j++) {
515       end += l_nn[j+1];
516     }
517     for (uint h_i = start; h_i < end; h_i++) {
518       hidden_layer[hidden_layer_index] = hls[h_i];
519       hidden_layer_index += 1;
520     }
521     return hidden_layer;
522   }
523 
524   function get_prediction(Submission sub, int[datapoint_size] data_point) private pure returns(int256[]) {
525     uint[] memory l_nn = new uint[](sub.num_neurons_hidden_layer.length + 2);
526     l_nn[0] = sub.num_neurons_input_layer;
527     for (uint i = 0; i < sub.num_neurons_hidden_layer.length; i++) {
528       l_nn[i+1] = sub.num_neurons_hidden_layer[i];
529     }
530     l_nn[sub.num_neurons_hidden_layer.length+1] = sub.num_neurons_output_layer;
531     return forward_pass(data_point, sub.weights, sub.biases, l_nn);
532   }
533 
534   function forward_pass(int[datapoint_size] data_point, int256[] weights, int256[] biases, uint[] l_nn) private pure returns (int256[]) {
535     // Initialize neuron arrays
536     int256[] memory input_layer = get_layer(l_nn[0]);
537     int256[] memory hidden_layers = get_hidden_layers(l_nn);
538     int256[] memory output_layer = get_layer(l_nn[l_nn.length-1]);
539 
540     // load inputs from input layer
541     for (uint input_i = 0; input_i < l_nn[0]; input_i++) {
542       input_layer[input_i] = data_point[input_i];
543     }
544     return forward_pass2(l_nn, input_layer, hidden_layers, output_layer, weights, biases);
545   }
546 
547   function forward_pass2(uint[] l_nn, int256[] input_layer, int256[] hidden_layers, int256[] output_layer, int256[] weights, int256[] biases) public pure returns (int256[]) {
548     // index_counter[0] is weight index
549     // index_counter[1] is hidden_layer_index
550     uint[] memory index_counter = new uint[](2);
551     for (uint layer_i = 0; layer_i < (l_nn.length-1); layer_i++) {
552       int256[] memory current_layer;
553       int256[] memory prev_layer;
554       // If between input and first hidden layer
555       if (hidden_layers.length != 0) {
556         if (layer_i == 0) {
557           current_layer = access_hidden_layer(hidden_layers, l_nn, layer_i);
558           prev_layer = input_layer;
559         // If between output and last hidden layer
560         } else if (layer_i == (l_nn.length-2)) {
561           current_layer = output_layer;
562           prev_layer = access_hidden_layer(hidden_layers, l_nn, (layer_i-1));
563         // If between hidden layers
564         } else {
565           current_layer = access_hidden_layer(hidden_layers, l_nn, layer_i);
566           prev_layer = access_hidden_layer(hidden_layers, l_nn, layer_i-1);
567         }
568       } else {
569         current_layer = output_layer;
570         prev_layer = input_layer;
571       }
572       for (uint layer_neuron_i = 0; layer_neuron_i < current_layer.length; layer_neuron_i++) {
573         int total = 0;
574         for (uint prev_layer_neuron_i = 0; prev_layer_neuron_i < prev_layer.length; prev_layer_neuron_i++) {
575           total += prev_layer[prev_layer_neuron_i] * weights[index_counter[0]];
576           index_counter[0]++;
577         }
578         total += biases[layer_i];
579         total = total / int_precision; // Divide by int_precision to scale down
580         // If between output and last hidden layer
581         if (layer_i == (l_nn.length-2)) {
582             output_layer[layer_neuron_i] = relu_activation(total);
583         } else {
584             hidden_layers[index_counter[1]] = relu_activation(total);
585         }
586         index_counter[1]++;
587       }
588     }
589     return output_layer;
590   }
591 
592   // Fallback function for sending ether to this contract
593   function () public payable {}
594 }