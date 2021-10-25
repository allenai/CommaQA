import logging

from commaqa.execution.constants import MATH_MODEL
from commaqa.execution.kblookup import KBLookup
from commaqa.execution.math_model import MathModel
from commaqa.execution.model_executer import ModelExecutor

logger = logging.getLogger(__name__)


def build_models(pred_lang_config, complete_kb):
    model_library = {}
    kblookup = KBLookup(kb=complete_kb)
    for model_name, configs in pred_lang_config.items():
        if model_name == MATH_MODEL:
            model = MathModel(predicate_language=configs,
                              model_name=model_name,
                              kblookup=kblookup)
        else:
            model = ModelExecutor(predicate_language=configs,
                                  model_name=model_name,
                                  kblookup=kblookup)
        model_library[model_name] = model
    return model_library


