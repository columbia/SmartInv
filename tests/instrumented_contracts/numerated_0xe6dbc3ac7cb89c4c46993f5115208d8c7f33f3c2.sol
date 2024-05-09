1 pragma solidity ^0.4.19;
2 
3 // Add your message to the word cloud: https://jamespic.github.io/ether-wordcloud
4 
5 contract WordCloud {
6   address guyWhoGetsPaid = msg.sender;
7   mapping (string => uint) wordSizes;
8   event WordSizeIncreased(string word, uint newSize);
9 
10   function increaseWordSize(string word) external payable {
11     wordSizes[word] += msg.value;
12     guyWhoGetsPaid.transfer(this.balance);
13     WordSizeIncreased(word, wordSizes[word]);
14   }
15 
16   function wordSize(string word) external view returns (uint) {
17     return wordSizes[word];
18   }
19 }