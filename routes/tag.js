var express = require("express");
var router = express.Router();

const tags = {
  1: {
    displayName: "happy",
    media: [
      {
        id: "1a",
        url: "https://media.giphy.com/media/rdma0nDFZMR32/giphy.gif",
        dateAdded: 123
      },
      {
        id: "1b",
        url: "https://media.giphy.com/media/12JKTRWNJuwbm0/giphy.gif",
        dateAdded: 456
      }
    ]
  },
  2: {
    displayName: "thinking",
    media: [
      {
        id: "2a",
        url: "https://media.giphy.com/media/rdma0nDFZMR32/giphy.gif",
        dateAdded: 789
      },
      {
        id: "2b",
        url: "https://media.giphy.com/media/12JKTRWNJuwbm0/giphy.gif",
        dateAdded: 101
      }
    ]
  }
};

/* list tags */
router.get("/", function(req, res, next) {
  const tagNames = Object.keys(tags)
    .map(tagId => tags[tagId])
    .map(t => t.displayName);
  res.send(tagNames);
});

/* List tag gifs */
router.get("/:tagId", function(req, res, next) {
  const tagId = req.params.tagId;
  const tagDetails = tags[tagId];

  res.send(tagDetails);
});

/* Save a new Gif */
router.post("/:tagId", function(req, res, next) {
  res.send("tags");
});

/* Delete a Gif from a tag */
router.delete("/:mediaId", function(req, res, next) {
  res.send("tags");
});

module.exports = router;
