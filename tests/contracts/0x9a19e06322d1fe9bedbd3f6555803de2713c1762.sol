// SPDX-License-Identifier: MIT
/*
oooooo   oooooo     oooo oooo         o8o      .             
 `888.    `888.     .8'  `888         `"'    .o8             
  `888.   .8888.   .8'    888 .oo.   oooo  .o888oo  .ooooo.  
   `888  .8'`888. .8'     888P"Y88b  `888    888   d88' `88b 
    `888.8'  `888.8'      888   888   888    888   888ooo888 
     `888'    `888'       888   888   888    888 . 888    .o 
      `8'      `8'       o888o o888o o888o   "888" `Y8bod8P' 
*/

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface IWhiteInstance {

    function token() external view returns (address);
    function denomination() external view returns (uint256);
    function deposit(bytes32 commitment) external payable;
    function withdraw(
        bytes calldata proof,
        bytes32 root,
        bytes32 nullifierHash,
        address payable recipient,
        address payable relayer,
        uint256 fee,
        uint256 refund
    ) external payable;
}


contract WhiteProxyLight {

    event EncryptedNote(address indexed sender, bytes encryptedNote);

    function deposit(
        IWhiteInstance _white,
        bytes32 _commitment,
        bytes calldata _encryptedNote
    ) external payable {
        _white.deposit{ value: msg.value }(_commitment);
        emit EncryptedNote(msg.sender, _encryptedNote);
    }

    function withdraw(
        IWhiteInstance _white,
        bytes calldata _proof,
        bytes32 _root,
        bytes32 _nullifierHash,
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _refund
    ) external payable {
        _white.withdraw{ value: msg.value }(_proof, _root, _nullifierHash, _recipient, _relayer, _fee, _refund);
    }

    function backupNotes(bytes[] calldata _encryptedNotes) external {
        for (uint256 i = 0; i < _encryptedNotes.length; i++) {
        emit EncryptedNote(msg.sender, _encryptedNotes[i]);
        }
    }
}