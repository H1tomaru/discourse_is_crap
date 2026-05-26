import LinkTo from '@ember/routing/link-to-component'
import dIcon from 'discourse/helpers/d-icon'

export default <template>
  <LinkTo @route="user.kek">
    {{dIcon "star-half-stroke"}}
    Отзывы
  </LinkTo>
</template>
