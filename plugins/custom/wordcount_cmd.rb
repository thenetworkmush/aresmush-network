module AresMUSH
    module Custom
        class WordCountCmd
            include CommandHandler
      
            attr_accessor :name
      
            def parse_args
              self.name = cmd.args || enactor_name
            end

            def format_number(number)
              number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
            end
            
            def handle
                ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
                  word_count = model.pose_word_count
                  scene_count = model.scenes_participated_in.size
                  words_per_scene = word_count / scene_count
                  word_count = format_number(word_count)
                  scene_count = format_number(scene_count)
                  words_per_scene = format_number(words_per_scene)
                  total_count = "#{model.name} has written", word_count, "words in", scene_count, "scenes for an average of", words_per_scene, "per scene."
                  msg = total_count.join(" ")
                  client.emit_success msg
                end
            end
        end
    end
end