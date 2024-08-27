// SPDX-Licnese-Identifier: MIT

pragma solidity ^0.8.26;

/// 1. Contract owner should be able to store the message
/// 2. We should keep count of likes and dislikes, if
///    message change we should reset likes and dislikes
/// 3. People should be able to donate ETH if they really like the message
contract SimpleSolidity {
    string message;

    function setMessage(string memory _newMessage) public {
        message = _newMessage;
    }
}
