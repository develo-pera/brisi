// SPDX-Licnese-Identifier: MIT

pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// 1. Contract owner should be able to store the message
/// 2. We should keep count of likes and dislikes, if
///    message change we should reset likes and dislikes
/// 3. People should be able to donate ETH if they really like the message
contract SimpleSolidity is Ownable(msg.sender) {
    string public message;
    uint256 public likesCount;
    uint256 public dislikesCount;

    event MessageChanged(string oldMessage, string newMessage);
    event Like(address indexed likedBy, string likedMessage);
    event Dislike(address indexed dislikedBy, string dislikedMessage);
    event Donation(address indexed donor, uint256 amount);

    function setMessage(string calldata _newMessage) public onlyOwner {
        likesCount = 0;
        dislikesCount = 0;
        string memory oldMessage = message;
        message = _newMessage;
        emit MessageChanged(oldMessage, _newMessage);
    }

    function like() public {
        likesCount++;
        emit Like(msg.sender, message);
    }

    function dislike() public {
        dislikesCount++;
        emit Dislike(msg.sender, message);
    }

    receive() external payable {
        emit Donation(msg.sender, msg.value);
    }
}
