using System;

namespace PixelVision8.Player
{
    public partial class GameChip
    {
        protected FontChip FontChip => Player.FontChip;
        
        protected int[] spriteIDs;
        protected int _index;
        protected int _spriteId;
        protected char character;
        protected int charOffset = 32;
       
        /// <summary>
        ///     A helper method to convert a string of characters into an array of sprite IDs.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="fontName"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public int[] ConvertTextToSprites(string text, string fontName = "default")
        {
            _total = text.Length;

            spriteIDs = new int[_total];

            //            char character;

            //            int spriteID, index;

            var fontMap = FontChip.ReadFont(fontName);

            // Test to make sure font exists
            if (fontMap == null) throw new Exception("Font '" + fontName + "' not found.");

            var totalCharacters = fontMap.Length;

            for (var i = 0; i < _total; i++)
            {
                character = text[i];
                _index = Convert.ToInt32(character) - charOffset;
                _spriteId = -1;

                if (_index < totalCharacters && _index > -1) _spriteId = fontMap[_index];

                spriteIDs[i] = _spriteId;
            }

            return spriteIDs;
        }
        
        public int[] FontChar(char character, string fontName, int[] data = null)
        {

            var fontMap = FontChip.ReadFont(fontName);

            // Test to make sure font exists
            if (fontMap == null) throw new Exception("Font '" + fontName + "' not found.");

            // TODO need to test this out
            id = ConvertTextToSprites(character.ToString(), fontName)[0];

            if (data != null)
            {
                FontChip.UpdateSpriteAt(id, data);

                return data;
            }

            FontChip.ReadSpriteAt(id, ref _tmpSpriteData);

            return _tmpSpriteData;
        }
    }
}