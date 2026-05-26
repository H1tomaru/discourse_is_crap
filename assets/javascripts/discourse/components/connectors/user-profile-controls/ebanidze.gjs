import dIcon from 'discourse/helpers/d-icon'

export default <template>
  <li>
    <LinkTo @route="user.kek" class="btn">
      {{dIcon "star-half-stroke"}}
      Отзывы
    </LinkTo>
  </li>
</template>

import dIcon from 'discourse/helpers/d-icon'
