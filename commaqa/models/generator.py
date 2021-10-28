import torch
from transformers import AutoConfig, AutoTokenizer, AutoModelWithLMHead


class LMGenerator:

    def __init__(self, model_path, device=None,
                 generation_args={}, encoder_args={}, decoder_args={}):
        if device is None:
            self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        else:
            self.device = device

        self.config = AutoConfig.from_pretrained(model_path)
        self.tokenizer = AutoTokenizer.from_pretrained(model_path)
        self.model = AutoModelWithLMHead.from_pretrained(model_path, config=self.config).to(
            self.device)
        self.generation_args = generation_args
        self.encoder_args = encoder_args
        self.decoder_args = decoder_args

    def generate_text_sequence(self, input_text):
        encoded_prompt = self.tokenizer.encode(input_text, **self.encoder_args)

        encoded_prompt = encoded_prompt.to(self.device)
        generation_outputs = self.model.generate(input_ids=encoded_prompt, **self.generation_args)

        if len(generation_outputs.shape) > 2:
            generation_outputs.squeeze_()

        generated_sequences = []

        for generated_sequence_idx, generated_output in enumerate(generation_outputs):
            generated_output = generated_output.tolist()
            text = self.tokenizer.decode(generated_output, **self.decoder_args)
            generated_sequences.append(text)
        return generated_sequences
